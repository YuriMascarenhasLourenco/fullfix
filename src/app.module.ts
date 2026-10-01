import { Module } from '@nestjs/common';
import { PrismaModule } from './database/prisma/prisma.module';
import { CustomersModule } from './modules/customers/customers.module';
import { ProductsModule } from './modules/products/products.module';
import { InventoryModule } from './modules/inventory/inventory.module';
import { OrdersModule } from './modules/orders/orders.module';

@Module({
  imports: [
    ProductsModule,
    InventoryModule,
    OrdersModule,
    CustomersModule,
    PrismaModule,
  ],
})
export class AppModule {}
