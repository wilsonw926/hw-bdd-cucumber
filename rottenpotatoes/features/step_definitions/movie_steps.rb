# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(movie)
  end
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  expect(/^.*?\b#{e1}\b.*?\b#{e2}\b.*?$/m).to match(page.body)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When (/I (un)?check the following ratings: (.*)/) do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(", ").each do |element|
    box = "ratings_"+element
    if uncheck == "un"
      uncheck(box)
    else
      check(box)
    end
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  expect(page).to have_xpath(".//table[@id='movies']//tr", :count => Movie.count+1)
end

Then(/I should see movies with the following ratings: (.*)/) do |rating_list|
  expect(page).to have_css('table#movies', :rating_list)
end

Then(/I should not see movies with the following ratings: (.*)/) do |rating_list|
  expect(page).to have_css('table#movies', !:rating_list)
end
