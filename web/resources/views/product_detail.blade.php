<!-- resources/views/product_detail.blade.php -->
<!DOCTYPE html>
<html>
<head>
    <title>{{ $productDetail->description ?? 'Product Detail' }}</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <div class="card">
            <div class="card-header">
                <h2>Product Detail</h2>
            </div>
            <div class="card-body">
                <h4 class="card-title">{{ $productDetail->description }}</h4>
                <p class="card-text">
                    <strong>Product ID:</strong> {{ $productDetail->productId }} <br>
                    <strong>Created At:</strong> {{ $productDetail->createdAt }} <br>
                    <strong>Updated At:</strong> {{ $productDetail->updatedAt }} <br>
                </p>
            </div>
        </div>
    </div>
</body>
</html>
