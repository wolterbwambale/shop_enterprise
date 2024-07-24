document.addEventListener("DOMContentLoaded", () => {
  const addItemButton = document.getElementById("add-item");
  const orderItemsContainer = document.getElementById("order_items");

  addItemButton.addEventListener("click", () => {
    const newItem = document.querySelector(".order-item").cloneNode(true);
    newItem.querySelectorAll("input").forEach(input => input.value = "");
    newItem.querySelectorAll(".remove-item").forEach(button => {
      button.addEventListener("click", () => {
        newItem.remove();
      });
    });
    orderItemsContainer.appendChild(newItem);
  });

  document.querySelectorAll(".remove-item").forEach(button => {
    button.addEventListener("click", () => {
      button.closest(".order-item").remove();
    });
  });
});
