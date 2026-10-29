/*
  Warnings:

  - You are about to drop the column `quantity` on the `warehouse_inventory` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Product" ADD COLUMN     "quantity" INTEGER NOT NULL DEFAULT 0;

-- AlterTable
ALTER TABLE "warehouse_inventory" DROP COLUMN "quantity",
ADD COLUMN     "version" INTEGER NOT NULL DEFAULT 1;
