# OscarsMates 
An application designed for tracking, rating, and comparing Oscar-winning movies. The app allows users to like movies, add reviews and interact with other film enthusiasts.

## Features
1. **Registration and Login**: Users can create accounts and log in to access all features.
2. **Movie List**: Create and manage a list of liked Oscar-winning movies.
3. **Reviews and Ratings**: Add reviews and rate movies to share your thoughts and recommendations.
4. **Friend Interactions**: Connect with friends, compare movie lists, and see what your friends are rating.

## Code Details
1. **Partials**: Used to DRY up the views.
2. **Associations**: `One-to-Many`: Used to define relationships where one entity can have many related entities. This is implemented using `has_many` and `belongs_to` ActiveRecord associations.
`Many-to-Many Through Associations`: Used to model the relationship between entities where each entity can have many of the other, through a join table.
3. **Validations**: Ensure the integrity of the data by validating attributes before saving them to the database. Common validations include `presence`and `uniqueness`.
4. **Flash Messages**: Provide feedback to users after they perform actions such as signing in, signing out, or submitting forms. 
5. **Nested Resources**: Organize related resources in a nested manner to reflect their relationships. For example, reviews nested under movies.
6. **Callbacks**: Used to perform actions at certain points in the lifecycle of an ActiveRecord object.

## Contributing
If you would like to contribute to this project, please fork the repository and submit a pull request with your improvements or bug fixes. All contributions are welcome!
