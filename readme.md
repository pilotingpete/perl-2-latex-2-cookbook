# Perl 2 Latex 2 Cookbook

## Description
Perl 2 Latex 2 Cookbook is a bit of a rube goldberg for typesetting and quickly editing/adding/deleting recepies to a cookbook without having to type out the <img src="https://latex.codecogs.com/gif.latex?\LaTeX" /> yourself - which we all know can be a bit tedious. 

The Perl script will parse a recipe text file with an arcane, but simple syntax, and build out the Latex. The location of the recipe files in folders dictate "Chapters".

Example of a recipe flat file:
```
t > Hummus
p > hummus.jpg
s > 4 Portions > 15 Min
i > 1 > Can > Chickpeas
i > 4 > Cloves > Garlic
i > 3 > Tbsp > Tahini
i > \fr12 > C > Lemon Juice
i > 1\fr12 > Tsp > Salt
i > 2 > Tbsp > Parsley
i > 1 > Tbsp > Olive Oil
a > Drain and rinse the chickpeas. Add all ingredients to a blender and blend until smooth. Optionally garnish with whole chickpeas, parsley, and/or olive oil.
```

This recipe gets output to pdf like so:

## Todo

Future upgrade ideas:
- Webapp with checkboxes and dropdowns instead of flat files for recipe "cards"
