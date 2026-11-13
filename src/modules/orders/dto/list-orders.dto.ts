import { IsDate, IsNumber, IsOptional, IsString, Min } from 'class-validator';

enum OrderStatus {
  PENDING = 'PENDING',
  PROCESSING = 'PROCESSING',
  SHIPPED = 'SHIPPED',
  DELIVERED = 'DELIVERED',
  CANCELLED = 'CANCELLED',
}
export class ListFilterOrdersDto {
  @IsOptional()
  @IsString()
  customerId?: string;

  @IsNumber()
  @Min(5)
  limit?: number;

  @IsNumber()
  @Min(0)
  offset?: number;

  @IsNumber()
  @Min(1)
  page?: number;

  @IsString()
  @IsOptional()
  status?: OrderStatus;

  @IsDate()
  createdFrom?: Date;

  @IsDate()
  createdTo?: Date;
}
