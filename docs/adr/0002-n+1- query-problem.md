# ADR 0002: Resolving the N+1 Query Problem in Warehouse Inventory Retrieval

**Status:** Accepted

**Date:** 2026-11-06

## Context

The warehouse selection process needs to identify which warehouses have sufficient inventory to fulfill a customer's order.

The current implementation retrieves all warehouses and then executes an individual database query for each warehouse to retrieve its inventory.

This results in an N+1 query problem.

For example, when retrieving 100 warehouses, the application executes:

- 1 query to retrieve warehouses.
- 100 additional queries to retrieve inventory.

This increases database round trips, query execution overhead, and response latency as the number of warehouses grows.

We need a more efficient data retrieval strategy.

## Decision

We decided to replace the individual inventory queries with a batch retrieval strategy.

The application will retrieve the relevant warehouse inventory records using a single database query, filtering by the requested product IDs and warehouse IDs.

The application will then perform the necessary grouping and warehouse eligibility calculations in memory.

We will use Prisma's `findMany` to retrieve the required records in bulk.

## Alternatives Considered

### 1. Individual Queries (N+1)

Rejected because the number of database round trips grows linearly with the number of warehouses.

### 2. Batch Retrieval

Selected because it reduces the number of database round trips and allows PostgreSQL to retrieve multiple relevant records in one query.

### 3. JOIN-Based Retrieval

Considered as an alternative to batch retrieval.

A JOIN can retrieve warehouse and inventory information in a single SQL statement, reducing application-side data processing.

However, the batch approach was selected initially because it provides a straightforward implementation using Prisma Client.

### 4. Raw SQL

Considered for more complex queries and potentially better control over query execution and aggregation.

Not selected initially because Prisma Client provides sufficient functionality for the current requirements.

## Consequences

### Positive

- Reduces database round trips.
- Eliminates the N+1 query pattern.
- Improves scalability when the number of warehouses increases.
- Reduces unnecessary database connection usage.

### Negative

- May retrieve more records than necessary if filters are not carefully designed.
- Requires additional application-side grouping and processing.
- Large batches may require pagination or chunking.
- JOIN-based queries may be more efficient for certain access patterns.

## Validation

The implementation will be validated through:

- Measuring the number of SQL queries executed.
- Comparing execution time before and after the change.
- Testing with different numbers of warehouses and products.
- Inspecting PostgreSQL execution plans using EXPLAIN ANALYZE.

The expected result is to reduce the number of database queries from N+1 to a constant number of queries for the retrieval operation.