/*
  Warnings:

  - You are about to drop the column `createdAt` on the `order` table. All the data in the column will be lost.
  - You are about to drop the column `totalAmount` on the `order` table. All the data in the column will be lost.
  - You are about to drop the column `updatedAt` on the `order` table. All the data in the column will be lost.
  - You are about to drop the column `createdAt` on the `orderItem` table. All the data in the column will be lost.
  - You are about to drop the column `orderId` on the `orderItem` table. All the data in the column will be lost.
  - You are about to drop the column `price` on the `orderItem` table. All the data in the column will be lost.
  - You are about to drop the column `productId` on the `orderItem` table. All the data in the column will be lost.
  - You are about to drop the column `updatedAt` on the `orderItem` table. All the data in the column will be lost.
  - You are about to drop the column `createdAt` on the `product` table. All the data in the column will be lost.
  - You are about to drop the column `description` on the `product` table. All the data in the column will be lost.
  - You are about to drop the column `updatedAt` on the `product` table. All the data in the column will be lost.
  - You are about to drop the column `warehouseId` on the `product` table. All the data in the column will be lost.
  - You are about to alter the column `price` on the `product` table. The data in that column could be lost. The data in that column will be cast from `DoublePrecision` to `Integer`.
  - You are about to drop the column `createdAt` on the `warehouse` table. All the data in the column will be lost.
  - You are about to drop the column `location` on the `warehouse` table. All the data in the column will be lost.
  - You are about to drop the column `updatedAt` on the `warehouse` table. All the data in the column will be lost.
  - You are about to drop the column `createdAt` on the `warehouseInventory` table. All the data in the column will be lost.
  - You are about to drop the column `productId` on the `warehouseInventory` table. All the data in the column will be lost.
  - You are about to drop the column `updatedAt` on the `warehouseInventory` table. All the data in the column will be lost.
  - You are about to drop the column `warehouseId` on the `warehouseInventory` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[order_id]` on the table `orderItem` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[product_id]` on the table `orderItem` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[sku]` on the table `product` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[warehouse_id]` on the table `warehouseInventory` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[product_id]` on the table `warehouseInventory` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `customer_id` to the `order` table without a default value. This is not possible if the table is not empty.
  - Added the required column `total_amount` to the `order` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updated_at` to the `order` table without a default value. This is not possible if the table is not empty.
  - Added the required column `warehouse_id` to the `order` table without a default value. This is not possible if the table is not empty.
  - Added the required column `order_id` to the `orderItem` table without a default value. This is not possible if the table is not empty.
  - Added the required column `product_id` to the `orderItem` table without a default value. This is not possible if the table is not empty.
  - Added the required column `unit_price` to the `orderItem` table without a default value. This is not possible if the table is not empty.
  - Added the required column `sku` to the `product` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updated_at` to the `product` table without a default value. This is not possible if the table is not empty.
  - Added the required column `latitude` to the `warehouse` table without a default value. This is not possible if the table is not empty.
  - Added the required column `longitude` to the `warehouse` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updated_at` to the `warehouse` table without a default value. This is not possible if the table is not empty.
  - Added the required column `product_id` to the `warehouseInventory` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updated_at` to the `warehouseInventory` table without a default value. This is not possible if the table is not empty.
  - Added the required column `warehouse_id` to the `warehouseInventory` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "order" DROP CONSTRAINT "order_userId_fkey";

-- DropForeignKey
ALTER TABLE "orderItem" DROP CONSTRAINT "orderItem_orderId_fkey";

-- DropForeignKey
ALTER TABLE "orderItem" DROP CONSTRAINT "orderItem_productId_fkey";

-- DropForeignKey
ALTER TABLE "product" DROP CONSTRAINT "product_warehouseId_fkey";

-- DropForeignKey
ALTER TABLE "warehouseInventory" DROP CONSTRAINT "warehouseInventory_productId_fkey";

-- DropForeignKey
ALTER TABLE "warehouseInventory" DROP CONSTRAINT "warehouseInventory_warehouseId_fkey";

-- AlterTable
ALTER TABLE "order" DROP COLUMN "createdAt",
DROP COLUMN "totalAmount",
DROP COLUMN "updatedAt",
ADD COLUMN     "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "customerId" INTEGER,
ADD COLUMN     "customer_id" INTEGER NOT NULL,
ADD COLUMN     "total_amount" DOUBLE PRECISION NOT NULL,
ADD COLUMN     "updated_at" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "warehouse_id" INTEGER NOT NULL,
ALTER COLUMN "userId" DROP NOT NULL;

-- AlterTable
ALTER TABLE "orderItem" DROP COLUMN "createdAt",
DROP COLUMN "orderId",
DROP COLUMN "price",
DROP COLUMN "productId",
DROP COLUMN "updatedAt",
ADD COLUMN     "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "order_id" INTEGER NOT NULL,
ADD COLUMN     "product_id" INTEGER NOT NULL,
ADD COLUMN     "unit_price" DOUBLE PRECISION NOT NULL;

-- AlterTable
ALTER TABLE "product" DROP COLUMN "createdAt",
DROP COLUMN "description",
DROP COLUMN "updatedAt",
DROP COLUMN "warehouseId",
ADD COLUMN     "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "sku" TEXT NOT NULL,
ADD COLUMN     "updated_at" TIMESTAMP(3) NOT NULL,
ALTER COLUMN "price" SET DATA TYPE INTEGER;

-- AlterTable
ALTER TABLE "warehouse" DROP COLUMN "createdAt",
DROP COLUMN "location",
DROP COLUMN "updatedAt",
ADD COLUMN     "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "latitude" DOUBLE PRECISION NOT NULL,
ADD COLUMN     "longitude" DOUBLE PRECISION NOT NULL,
ADD COLUMN     "updated_at" TIMESTAMP(3) NOT NULL;

-- AlterTable
ALTER TABLE "warehouseInventory" DROP COLUMN "createdAt",
DROP COLUMN "productId",
DROP COLUMN "updatedAt",
DROP COLUMN "warehouseId",
ADD COLUMN     "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "product_id" INTEGER NOT NULL,
ADD COLUMN     "updated_at" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "version" INTEGER NOT NULL DEFAULT 1,
ADD COLUMN     "warehouse_id" INTEGER NOT NULL;

-- CreateTable
CREATE TABLE "customer" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "customer_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "customer_email_key" ON "customer"("email");

-- CreateIndex
CREATE UNIQUE INDEX "orderItem_order_id_key" ON "orderItem"("order_id");

-- CreateIndex
CREATE UNIQUE INDEX "orderItem_product_id_key" ON "orderItem"("product_id");

-- CreateIndex
CREATE UNIQUE INDEX "product_sku_key" ON "product"("sku");

-- CreateIndex
CREATE UNIQUE INDEX "warehouseInventory_warehouse_id_key" ON "warehouseInventory"("warehouse_id");

-- CreateIndex
CREATE UNIQUE INDEX "warehouseInventory_product_id_key" ON "warehouseInventory"("product_id");

-- AddForeignKey
ALTER TABLE "order" ADD CONSTRAINT "order_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "customer"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order" ADD CONSTRAINT "order_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "warehouseInventory" ADD CONSTRAINT "warehouseInventory_warehouse_id_fkey" FOREIGN KEY ("warehouse_id") REFERENCES "warehouse"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "warehouseInventory" ADD CONSTRAINT "warehouseInventory_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
