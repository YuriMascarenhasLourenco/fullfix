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

    for (const item of createOrderDto.item) {
      const product = await this.prisma.product.findUnique({
        where: { id: item.productId },
      });

      if (!product) {
        throw new Error(`Product ${item.productId} not found`);
      }
    }
    const order = await this.prisma.order.create({
      data: {
        customerId: createOrderDto.customerId,
        warehouseId: createOrderDto.warehouseId,
        status: 'PENDING',
        totalAmount: createOrderDto.item.reduce(
          (acc, item) => acc + item.quantity * item.unitPrice,
          0,
        ),
      },
    });
    const orderItems = await this.prisma.orderItem.createMany({
      data: createOrderDto.item.map((item) => ({
        orderId: Number(order.id),
        productId: item.productId,
        quantity: item.quantity,
        unitPrice: item.unitPrice,
      })),
    });
    const updateInventory = await this.prisma.product.updateMany({
      where: {
        id: { in: createOrderDto.item.map((item) => item.productId) },
      },
      data: {
        quantity: {
          decrement: createOrderDto.item.reduce(
            (acc, item) => acc + item.quantity,
            0,
          ),
        },
      },
    });
    return { order, orderItems, updateInventory };
  }
  async findAll() {
    return await this.prisma.customer.findMany({});
  }
}
