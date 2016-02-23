# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    steps %Q{
      Given I have added "#{movie[:title]}" with rating "#{movie[:rating]}", date "#{movie[:release_date]}"
    }
  end
end

Given /I have added "(.*)" with rating "(.*)", date "(.*)"/ do |title, rating, date|
  movie_hash = {title: title, rating: rating, release_date: date}
  Movie.create! movie_hash
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  e1_before_e2 = /#{e1}.*#{e2}/m
  page.body.should =~ e1_before_e2
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  ratings = rating_list.split(', ')
  if uncheck == "un"
    ratings.each do |rating|
      uncheck("ratings_#{rating}")
    end
  else
    ratings.each do |rating|
      check("ratings_#{rating}")
    end
  end
end

Then /I should see (.*) rows/ do |num_rows|
  rows = page.all('table#movies tr').count
  rows.should == Integer(num_rows)
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  step "I should see 11 rows"
end
