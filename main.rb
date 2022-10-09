require_relative "lib/questions_collection"
require "timeout"

PATH_TO_XML = "#{File.dirname(__FILE__)}/data/questions.xml"
questions = QuestionsCollection.from_file(PATH_TO_XML)

puts <<~HELLO

  Добро пожаловать на викторину!
  В качестве ответа введите номер выбранного варианта
  Если вы не успеете ответить на вопрос за отведенное время - игра закончится!
  Нажмите Enter, если готовы
HELLO
answer = gets

questions.to_a.shuffle.each do |question|
  puts question.print_question
  print "> "

  # Если пользователь отвечает слишком долго, то викторина заканчивается
  begin
    Timeout::timeout(question.timer) { answer = gets.to_i }
  rescue Timeout::Error
    puts "Время вышло!"
    break
  end

  if question.right?(answer)
    questions.accept_answer(question)
    puts "Верно!"
  else
    puts "Неверно! Правильный ответ - #{question.right_answer}"
  end
end

puts
puts "Вы ответили на #{questions.count_right_answers} вопросов из #{questions.size}"
puts "Ваш счет: #{questions.total_points}"
