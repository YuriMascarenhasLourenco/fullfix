import { BadRequestException, Injectable } from '@nestjs/common';
import { Prisma } from 'generated/prisma/client';
import { PrismaService } from 'src/database/prisma/prisma.service';
import { CreateOrderDto } from './dto/create-order.dto';

@Injectable()
export class OrdersService {
  constructor(private readonly prisma: PrismaService) {}

  async create(createOrderDto: CreateOrderDto) {
    const customer = await this.prisma.customer.findUnique({
      where: { id: createOrderDto.customerId },
    });

    if (!customer) {
      throw new BadRequestException('Customer not found');
    }

    const requestedQuantities = new Map<number, number>();
    for (const item of createOrderDto.item) {
      if (!Number.isInteger(item.quantity) || item.quantity <= 0) {
        throw new BadRequestException(
          'Item quantity must be a positive integer',
        );
      }

      requestedQuantities.set(
        item.productId,
        (requestedQuantities.get(item.productId) ?? 0) + item.quantity,
      );
    }

    const totalAmount = createOrderDto.item.reduce(
      (sum, item) => sum + item.quantity * item.unitPrice,
      0,
    );

    for (let attempt = 1; attempt <= 3; attempt++) {
      try {
        return await this.prisma.$transaction(
          async (tx) => {
            const values = Prisma.join(
              [...requestedQuantities].map(
                ([productId, quantity]) =>
                  Prisma.sql`(${productId}, ${quantity})`,
              ),
            );
            const updatedProducts = await tx.$queryRaw<{ id: number }[]>(
              Prisma.sql`
                UPDATE "Product" AS p
                SET "quantity" = p."quantity" - requested."quantity"
                FROM (VALUES ${values}) AS requested("productId", "quantity")
                WHERE p."id" = requested."productId"
                  AND p."quantity" >= requested."quantity"
                RETURNING p."id"
              `,
            );

            if (updatedProducts.length !== requestedQuantities.size) {
              throw new BadRequestException(
                'Insufficient stock or product not found',
              );
            }

            const order = await tx.order.create({
              data: {
                customerId: createOrderDto.customerId,
                warehouseId: createOrderDto.warehouseId,
                status: 'PENDING',
                totalAmount,
              },
            });

            await tx.orderItem.createMany({
              data: createOrderDto.item.map((item) => ({
                orderId: order.id,
                productId: item.productId,
                quantity: item.quantity,
                unitPrice: item.unitPrice,
              })),
            });

            return order;
          },
          {
            isolationLevel: Prisma.TransactionIsolationLevel.Serializable,
          },
        );
      } catch (error) {
        const isRetryable =
          error instanceof Prisma.PrismaClientKnownRequestError &&
          error.code === 'P2034';

        if (!isRetryable || attempt === 3) {
          throw error;
        }
      }
    }

    throw new Error('Transaction retry limit exceeded');
  }

  async findAll() {
    return await this.prisma.customer.findMany({});
  }
}
