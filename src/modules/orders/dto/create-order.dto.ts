export class CreateOrderDto {
  customerId!: number;
  warehouseId!: number;
  shippingAddress!: {
    latitude: number;
    longitude: number;
  };
  item!: [
    {
      productId: number;
      quantity: number;
      unitPrice: number;
    },
  ];
}
