document.addEventListener('DOMContentLoaded', function() {
    var menuGroups = document.querySelectorAll('.menu-group');
    var productButtons = document.querySelectorAll('.product-btn');
  
    // Initially hide all product buttons
    productButtons.forEach(function(button) {
      button.parentNode.style.display = 'none';
    });
  
    // Add click event listeners to menu groups
    menuGroups.forEach(function(menuGroup) {
      menuGroup.addEventListener('click', function(event) {
        event.preventDefault();
        var categoryId = menuGroup.getAttribute('data-category-id');
  
        // Hide all product buttons
        productButtons.forEach(function(button) {
          button.parentNode.style.display = 'none';
        });
  
        // Show product buttons for selected category
        var productGroup = document.querySelectorAll('.product-group[data-category="' + categoryId + '"]');
        productGroup.forEach(function(group) {
          group.style.display = 'block';
        });
      });
    });
  
    // Add click event listeners to product buttons
    productButtons.forEach(function(button) {
      button.addEventListener('click', function() {
        var productId = this.getAttribute('data-product-id');
        var productName = this.getAttribute('data-product-name');
        var productPrice = this.getAttribute('data-product-price');
  
        // Example: Update order form, send request to server, etc.
        // Add your logic here for adding products to the order
        console.log(productId, productName, productPrice);
      });
    });
  });
  