require 'fileutils'
require 'faker'
require 'strings-case'
strings = Strings::Case.new

num_paragraphs_body_min = 1
num_paragraphs_body_max = 10

num_sentence_paragraph_min = 3
num_sentence_paragraph_max = 8

num_words_title_min = 1
num_words_title_max = 6

date_min = '2014-09-23'
date_max = Date.today

categories = []
Dir.glob('categories/*').each do|f|
    c = File.basename(f, ".*")
    if c.to_s != "latest"
        categories.append(c)
    end
end

task :fake_posts, [:num1] do |t, args|
    count = args[:num1].to_i

    count.times.each do
        category_index = rand(0..categories.length()-1)
        num_paragraphs_body = rand(num_paragraphs_body_min..num_paragraphs_body_max)
        num_words_title = rand(num_words_title_min..num_words_title_max)
        
        title_words = Faker::Lorem.words(number: num_words_title)
        date = Faker::Date.between(from:date_min, to:date_max).to_s
        kebab_title = [date].concat(title_words).join('-')
        
        file = "portfolio/_posts/" + kebab_title + ".md"
        title =  strings.titlecase(title_words.join(' ')).to_s
        category = categories[category_index].to_s
        body = ""
        (1..num_paragraphs_body).each do
            num_sentences = rand(num_sentence_paragraph_min..num_sentence_paragraph_max)
            body = body + Faker::Lorem.paragraph(sentence_count: num_sentences) + "\n"
        end
               
        File.open(file, 'w') do |f|
            f.write("---\n")
            f.write("layout: post\n")
            f.write("title: " + title + "\n")
            f.write("categories: [" + category + "]\n")
            f.write('date: ' + date.to_s + "\n")
            f.write("---\n")
            f.write(body)
        end
    end
end

