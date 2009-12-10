
def fake_latin_generator(min_words=5, max_words=25)
  words = %w{Lorem ipsum dolor sit amet consectetur adipisicing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua enim ad minim veniam quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur excepteur sint occaecat cupidatat non proident sunt in culpa qui officia deserunt mollit anim id est laborum}
  string = ''
  count = rand(max_words) + min_words
  count = min_words if count < min_words
  count = max_words if count > max_words
  1.upto(count) do
    string = string + ' ' + words[rand(words.size)]
  end
  string.strip.capitalize
end

def fake_title(min_words=3, max_words=15)
  fake_latin_generator(min_words, max_words)
end

def fake_body(min_words=10, max_words=50)
  fake_latin_generator(min_words, max_words)
end

