
- [x] add a variable / class for the app bar (DRY)

- [x] Make some margins around the screen for better display

- [x] Rename 'screen' folder to 'pages'

- [x] Create a 'models' folder and add 'Button' class and any element that is repeatedly used

- [x] Improve the logic of the Navigation Stack

- [x] Create a folder called 'fonts' (outside the 'lib' folder):
	- contain the font family used by the app
	- add it to the dependencies (pubspec.yaml)

- [x] Add a bottom nav-bar (Non-functional btw)

- [x] Stop using static colors and use AppColors() instead :>

- [ ] Implement a Loading Screen (a bouncing logo or something)

- [ ] Handling account sessions efficiently to prevent the user from logging in each time, such that if the user already logged in.. redirect to the dashboard.. not the welcome screen

- [ ] After login.. Empty the stack and push the home page

- [ ] Fix when you are at the root of the application, pressing the back button would pop the root and close the app.

- [ ] Add hints to each button

- [ ] Swipe down to reload dashboard

- [ ] Some validations in sign up
	- [ ] Name must be between 3 and 20 letters
	- [ ] Confirm password logic

- [ ] Currently the app doesn't allow multiple account instances with the same email.. Solve the problem by adding linked accounts feature

After we finish:

- [ ] Making the app theme convenient with the idea

- [x] Add dark mode
