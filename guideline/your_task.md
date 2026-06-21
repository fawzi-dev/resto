Alright, putting on my developer hat! Looking at the designer's spec for this **RTL (Right-to-Left)** Restaurant Menu screen, here is exactly how I would plan, structure, and build this UI step-by-step.

---

## Phase 1: Foundation & Global Configuration

Before writing any layout code, I need to set up the environment to support the Kurdish language and RTL layout natively.

- **Step 1: Enable Global RTL Support** I'll configure the application to force RTL layout globally or dynamically switch based on the user's language locale (`I18nManager.forceRTL(true)` in React Native or setting `textDirection: TextDirection.rtl` in Flutter). This ensures that flex directions automatically swap (`flex-start` becomes the right side).
- **Step 2: Font Embedding** Standard system fonts often render Kurdish/Arabic scripts poorly. I will embed a high-quality, readable font family supporting the Arabic/Persian/Kurdish character sets (such as **Vazirmatn**, **Noto Sans Arabic**, or **Inter Arabic**) into the project's asset folder and define it in our global theme.
- **Step 3: Theme Definitions (Design Tokens)** I'll set up the color constants to match the UI:
- `PrimaryGreen`: `#2ecc71` (or the exact hex code of that vivid green button)
- `BackgroundLight`: `#f8f9fa`
- `TextDark`: `#2c3e50`
- `TextMuted`: `#7f8c8d`
- `DangerRed`: `#e74c3c`

---

## Phase 2: Component Architecture Breakdowns

To keep the code clean and maintainable, I will break this screen down into reusable atomic components:

```
└── RestaurantMenuScreen (Parent Screen Container)
    ├── HeaderNavigation (Component)
    ├── SearchBar (Component)
    ├── QuickActionButtons (Row Component)
    ├── CategoryCarousel (Horizontal Scroll Component)
    └── FoodGrid (Vertical Grid Component)
        └── FoodCard (Individual Reusable Card Component)

```

---

## Phase 3: Step-by-Step Layout Implementation

### Step 1: Main Scaffold & Safe Area

I'll wrap the entire screen in a `SafeAreaView` (or `SafeArea` widget) to handle device notches. The overall screen layout will be a vertical column with a slight padding on the horizontal sides (around `16px`).

### Step 2: Build the Header & Search Bar

- **Header:** Use a row wrapper with `justify-content: space-between`. I'll render the notification bell icon button on the left, the title text `ڕیستۆرانتەکەم` in the center (bold, approx `18px`), and the shopping bag icon on the right.
- **Search Bar:** Below the header, create a text input container. Give it a high `border-radius: 25px` and a light grey background. Since RTL is active, I'll place the magnifying glass icon on the far right of the container, followed by the text input field stretching to the left.

### Step 3: Implement Quick Action Buttons

I'll create a `Row` layout containing the two buttons.

- Give each button `flex: 1` so they take up equal halves of the screen width, with a `gap` of `12px` between them.
- The right button gets a solid background with white text and a white icon.
- The left button gets a transparent background with a green border, green text, and a green icon.

### Step 4: The Category Carousel (Horizontal List)

- I'll use a horizontal list component (like `FlatList` with `horizontal={true}` or a `ListView.builder` with a horizontal scroll direction).
- **State Hook:** I'll introduce an `activeCategoryId` state tracking variable.
- If the card’s ID matches the active state, apply conditional styling (solid green background, white text). If it doesn't, apply the default inactive styling (white background, grey border).

### Step 5: The Food Items Grid (Vertical List)

This is the most heavy-lifting part of the UI.

- I'll use a 2-column layout grid.
- **Building the `FoodCard` component:**
- Top section: Image wrapper with `overflow: hidden` and a fixed aspect ratio so all food pictures look uniform regardless of upload dimensions.
- Middle section: Item Title and Description stacked vertically (`flex-direction: column`, aligned right).
- Bottom section: A horizontal row containing the price (`8,000 دینار`) on the right side and the action controls (Edit/Delete icons) wrapped in small interactive hit-boxes on the left.

---

## Phase 4: Interactions, State & Mock Data

- **Mock Data Array:** I'll create an array of objects to mock the API response, passing down titles, image URLs, descriptions, and prices.
- **Delete Safeguard:** For the delete icon button, I will map its `onPress`/`onTap` event to trigger a native platform Alert dialog (`Alert.alert()` or a custom modal) to confirm the destructive action before modifying the state array.

---

Which mobile development framework (like React Native, Flutter, or native Swift/Kotlin) are we building this in? I can tailor the exact code snippets or layout properties for that framework if you'd like.
