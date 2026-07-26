library(dplyr)

test_that('missing columns', {

  df1 <- tibble(
    Id = '12345',
    Store = 'Store1',
    Price = 10
  )

  df2 <- tibble()

  df3 <- tibble(
    Price = 10,
    Amount = 2
  )

  v1 <- data_validate(df1)
  v2 <- data_validate(df2)
  v3 <- data_validate(df3)

  expect_equal(v1$missing_cols, c('Item', 'Amount'))
  expect_null(v1$price_error)
  expect_null(v1$amount_error)
  expect_null(v1$na_counts)

  expect_equal(v2$missing_cols, c('Id', 'Store', 'Item', 'Price', 'Amount'))
  expect_null(v2$price_error)
  expect_null(v2$amount_error)
  expect_null(v2$na_counts)

  expect_equal(v3$missing_cols, c('Id', 'Store', 'Item'))
  expect_null(v3$price_error)
  expect_null(v3$amount_error)
  expect_null(v3$na_counts)

})




test_that('Price is different than a number > 0', {

  df1 <- tibble(
    Id = c(1, 2),
    Store = c('Store1', 'Store2'),
    Item = c('Item1', 'Item2'),
    Price = c(1, -10),
    Amount = c(1, 2)
  )

  df2 <- tibble(
    Id = c(1, 2),
    Store = c('Store1', 'Store2'),
    Item = c('Item1', 'Item2'),
    Price = c(NA, 2),
    Amount = c(1, 2)
  )

  df3 <- tibble(
    Id = c(1, 2),
    Store = c('Store1', 'Store2'),
    Item = c('Item1', 'Item2'),
    Price = c(3, NULL),
    Amount = c(1, 2)
  )

  df4 <- tibble(
    Id = c(1, 2),
    Store = c('Store1', 'Store2'),
    Item = c('Item1', 'Item2'),
    Price = c(0, 4),
    Amount = c(1, 2)
  )

  v1 <- data_validate(df1)
  v2 <- data_validate(df2)
  v3 <- data_validate(df3)
  v4 <- data_validate(df4)

  expect_equal(length(v1$missing_cols), 0)
  expect_equal(v1$price_error, c(FALSE, TRUE))

  expect_equal(v2$price_error, c(NA, FALSE))
  expect_equal(v2$na_counts, c(Id = 0, Store = 0, Item = 0, Price = 1, Amount = 0))

  expect_equal(v3$price_error, c(FALSE, FALSE))
  expect_equal(v3$na_counts, c(Id = 0, Store = 0, Item = 0, Price = 0, Amount = 0))

  expect_equal(v4$price_error, c(TRUE, FALSE))
  expect_equal(v4$na_counts, c(Id = 0, Store = 0, Item = 0, Price = 0, Amount = 0))

})


test_that('Amount is different than a number > 0', {

  df1 <- tibble(
    Id = c(1, 2),
    Store = c('Store1', 'Store2'),
    Item = c('Item1', 'Item2'),
    Price = c(1, 2),
    Amount = c(1, -3)
  )

  df2 <- tibble(
    Id = c(1, 2),
    Store = c('Store1', 'Store2'),
    Item = c('Item1', 'Item2'),
    Price = c(1, 2),
    Amount = c(NA, 2)
  )

  df3 <- tibble(
    Id = c(1, 2),
    Store = c('Store1', 'Store2'),
    Item = c('Item1', 'Item2'),
    Price = c(1, 2),
    Amount = c(0, 4)
  )

  v1 <- data_validate(df1)
  v2 <- data_validate(df2)
  v3 <- data_validate(df3)

  expect_equal(v1$amount_error, c(FALSE, TRUE))

  expect_equal(v2$amount_error, c(NA, FALSE))
  expect_equal(v2$na_counts, c(Id = 0, Store = 0, Item = 0, Price = 0, Amount = 1))

  expect_equal(v3$amount_error, c(TRUE, FALSE))

})
