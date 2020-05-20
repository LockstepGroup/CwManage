class Product {
    [int]$ProductId
    $FullData

    [decimal]$Price
    [decimal]$TotalPrice
    [decimal]$Cost
    [decimal]$TotalCost
    [int]$Quantity

    [string]$ProductClass

    ##################################### Constructors #####################################
    # Constructor with no parameter
    Product() {
    }
}