import { Injectable } from '@nestjs/common';
import { CreateOrderDto } from './dto/create-order.dto';
import { PrismaService } from 'src/database/prisma/prisma.service';

@Injectable()
export class OrdersService {
  constructor(private readonly prisma: PrismaService) {}
  async create(createOrderDto: CreateOrderDto) {
    const validateCustomer = await this.prisma.customer.findUnique({
      where: { id: createOrderDto.customerId },
    });

    if (!validateCustomer) {
      throw new Error('Customer not found');
    }
    const productIds = [
      ...new Set(createOrderDto.item.map((item) => item.productId)),
    ];
    const products = await this.prisma.product.findMany({
      where: {
        id: { in: createOrderDto.item.map((item) => item.productId) },
      },
    });
    const foundProductIds = new Set(products.map((product) => product.id));

    for (const productId of productIds) {
      if (!foundProductIds.has(productId)) {
        throw new Error(`Product ${productId} not found`);
      }
    }
    await this.prisma.$transaction(
      async (tx) => {
        const availableProducts = await tx.product.findMany({
          where: {
            id: { in: productIds },
            quantity: {
              gte: { in: createOrderDto.item.map((item) => item.quantity) },
            },
          },
        });
        const order = await tx.orderItem.createMany({
          where: {
            customerId: createOrderDto.customerId,
          },
          data: {
            ...createOrderDto.item.map((item) => ({
              productId: item.productId,
              quantity: item.quantity,
              unitPrice: item.unitPrice,
            })),
          },
        });
        const updatedProducts = await tx.product.updateMany({
          where: {
            id: { in: productIds },
            quantity: {
              gte: { in: createOrderDto.item.map((item) => item.quantity) },
            },
          },
          data: {
            quantity: {
              decrement: {
                in: createOrderDto.item.map((item) => item.quantity),
              },
            },
          },
        });
      },
      {
        isolationLevel: 'Serializable',
      },
    );
  }
  async findAll() {
    return await this.prisma.customer.findMany({});
  }
}
