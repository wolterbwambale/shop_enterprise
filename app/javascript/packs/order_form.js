document.addEventListener('DOMContentLoaded', function() {
    document.getElementById("add-order-item").addEventListener("click", (e) => {
      e.preventDefault();
      const orderItems = document.getElementById("order-items");
      const newItem = document.querySelector(".order-item").cloneNode(true);
      newItem.querySelector("select").selectedIndex = 0;
      newItem.querySelector("input[type='number']").value = 1;
      orderItems.appendChild(newItem);
    });
  
    document.addEventListener("click", (e) => {
      if (e.target && e.target.classList.contains("remove-order-item")) {
        e.preventDefault();
        e.target.closest(".order-item").remove();
      }
    });
  });
  