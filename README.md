# Zstore, a higher form of shopping native iOS application.

This application is entirely built without using any third party libraries

# Features
1. Browse products catalog
2. Filter products by category
3. Apply offer, and discount calculation is done based on the percentage of offer given by the card providers
4. Sort the products by rating or price
5. If any link is present in product description, click the product to explore more about it
6. And more importantly, search a product by the search term.

# Key Decisions
1. Compositional Layout were used to design categories and card offers UI
2. Products were displayed using Table View. The products fetch, sort, filter and discount calculation logic was implemented utilizing NSFetchResultsController (Core Data).
3. Entire UI was implemented with Auto Layout Constraints without using StoryBoards.
4. For different device sizes, constraints were applied accordingly (i.e, for iPhone 15 or iPhone SE the layout gets aligned)
5. MVVM code architecture was used
