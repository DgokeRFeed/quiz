require "rexml/document"
require_relative "question"

# Класс, отвечающий за логику викторины
class QuestionsCollection
  attr_accessor :total_points, :count_right_answers

  # Метод считывает вопросы и ответы из XML файла и создает массив вопросов
  def self.from_file(path)
    file = File.new(path)
    doc = REXML::Document.new(file)
    file.close

    questions =
      doc.root.elements.map do |question|
        points = question.attributes["points"].to_i
        timer = question.attributes["timer"].to_i
        text = question.elements["text"].text

        right_answer =
          question.get_elements("variants/variant")
                  .find { |variant| variant.attributes["right"] == "true" }
                  .text

        answers = question.get_elements("variants/variant").map(&:text)

        Question.new(
          points: points,
          timer: timer,
          text: text,
          right_answer: right_answer,
          answers: answers
        )
      end

    new(questions)
  end

  def initialize(questions)
    @questions = questions
    @total_points = 0
    @count_right_answers = 0
  end

  def accept_answer(question)
    @total_points += question.points
    @count_right_answers += 1
  end

  def size
    @questions.size
  end

  def to_a
    @questions
  end
end
