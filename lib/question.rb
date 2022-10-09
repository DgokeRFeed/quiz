# Класс, отвечающий за один конкретный вопрос
class Question
  attr_reader :text, :answers, :right_answer, :points, :timer

  def initialize(params)
    @text = params[:text]
    @answers = params[:answers].shuffle
    @right_answer = params[:right_answer]
    @points = params[:points]
    @timer = params[:timer]
  end

  def print_answers
    @answers.map.with_index(1) { |answer, index| "#{index}: #{answer}" }.join("\n")
  end

  def print_question
    <<~QUESTION

      #{@text} (#{@timer} сек. на ответ, стоимость: #{@points})

      Варианты ответа:
      #{print_answers}

    QUESTION
  end

  def right?(variant)
    variant - 1 == answers.index(@right_answer)
  end
end
