Here is a complete, developer-ready UX/UI breakdown of the provided screen.

### **Screen Overview**

- **Screen Purpose:** Restaurant Menu Management Panel ("My Restaurant" / ڕیستۆرانتەکەم). This is a vendor-side or admin-side screen where a restaurant owner manages their menu categories and food items.
- **Layout Orientation:** **Strictly RTL (Right-to-Left)**. Text alignment, icon placements, and reading flow must accommodate the Central Kurdish (Sorani) language.

---

### **1. Top Header & Navigation Bar**

- **Title Text:** `ڕیستۆرانتەکەم` (_My Restaurant_). Centered.
- **Left Icon Component:** Notification Bell with a green status/badge dot.
- **Right Icon Component:** Shopping Bag/Order basket icon.
- **Interaction:** \* Tapping the bell opens notifications.
- Tapping the bag navigates to incoming or active orders.

### **2. Search Bar**

- **Placeholder Text:** `گەڕان بەدوای خواردن` (_Search for food_).
- **Icon:** Magnifying glass aligned to the **right** side of the input field (due to RTL).
- **UI Specs:** Rounded corners (approx. `border-radius: 24px`), light grey background color, subtle inner shadow or flat borderless design.
- **Interaction:** Auto-focuses on tap, opens keyboard, and dynamically filters the "Foods" grid below as the user types.

### **3. Global Quick Actions (Primary/Secondary Buttons)**

Two horizontal buttons placed below the search bar to add new items.

- **Right Button (Primary Action):** `زیادکردنی خواردن` (_Add Food_).
- **Style:** Solid green background, white text, white `+` icon on the right.

- **Left Button (Secondary Action):** `زیادکردنی بەش` (_Add Section / Category_).
- **Style:** White background, green border, green text, green `+` icon on the right.

- **Behavior:** Both buttons should trigger a modal or navigate to a form creation screen.

---

### **4. Categories / Sections Carousel (`بەشەکان`)**

A horizontally scrollable list allows the admin to filter items by category.

- **Section Header:** `بەشەکان` (_Sections / Categories_). Aligned right.
- **Active State Card:** `هەموو` (_All_). Solid green background, white text, featuring a pizza slice icon.
- **Inactive State Cards:** `پیتزا` (_Pizza_), `بەرگر` (_Burger_), `شاورمە` (_Shawarma_). White background, thin grey border, dark text, with corresponding food icons.
- **Developer Note:** Ensure `overflow-x: scroll` is enabled with scroll indicators hidden. Active state switches dynamically on tap.

---

### **5. Food Items Grid (`خواردنەکان`)**

A 2-column responsive grid showing the active menu items.

- **Section Header:** `خواردنەکان` (_Foods / Items_). Aligned right.
- **Card Component Breakdown:**
- **Product Image:** Top of the card, fixed aspect ratio (approx 4:3), smooth `border-radius`.
- **Item Title:** Aligned right. Examples from image: `شاورمەی گۆشت` (_Meat Shawarma_), `بەرگر دبل پەنیر` (_Double Cheese Burger_), `زەڵاتەی ئەمریکی` (_American Salad_).
- **Item Description/Subtext:** Gray text, smaller font. _Note: The current image uses the placeholder text `بەرگری تایبەت و دبل پەنیر` (Special burger and double cheese) for all items. Ensure this pulls dynamically from the database description field._
- **Price Tag:** `8,000 دینار` (_8,000 Dinar_). Displayed in green, aligned right.
- **Action Footer (Inline Controls):** \* **Edit Button (Green Outline Icon):** Opens the item modifier page.
- **Delete Button (Red Outline Icon):** Triggers a "Are you sure you want to delete this item?" confirmation dialog box before executing the API call.

---

### **Technical Implementation Checklist for Backend/Frontend Integration**

- [ ] **RTL Support:** Ensure your layout engine handles switching flex-directions natively for Arabic/Kurdish script.
- [ ] **Currency Formatting:** The pricing numbers should fetch dynamically and append the local currency string (`دینار`).
- [ ] **Image Caching:** Food item cards should implement lazy loading or image caching to keep scrolling smooth.
- [ ] **Empty States:** Design a fallback layout if a category has 0 items (e.g., "No items in this section yet. Click 'Add Food' to get started").
