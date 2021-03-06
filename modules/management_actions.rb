module ManagementActions
  CARDS_TYPES = I18n.t(:cards_types).values

  def destroy_account
    outputer.destroy_account
    current_account.destroy if gets.chomp == MainMenu::YES_ANSWER
  end

  def show_cards
    return outputer.no_cards unless current_account.cards.any?

    current_account.cards.each { |card| puts "- #{card.number}, #{card.type}" }
  end

  def create_card
    loop do
      card_type = card_type_input
      break current_account.add_card card_type if CARDS_TYPES.include? card_type

      outputer.wrong_card_type
    end
  end

  def destroy_card
    loop do
      operation = __method__.to_s
      back_to_menu { outputer.no_cards } unless current_account.cards.any?

      outputer.show_cards_list current_account.cards, I18n.t('destroy_card.prompt_delete')
      answer = gets.chomp
      back_to_menu if answer == MainMenu::EXIT_COMMAND
      next outputer.wrong_number operation unless answer.to_i.between?(1, current_account.cards.length)

      confirm_destroying_card answer
    end
  end

  private

  def confirm_destroying_card(card_index)
    outputer.confirm_destroying_card current_account.cards[card_index.to_i - 1].number
    confirmation = gets.chomp
    back_to_menu { current_account.destroy_card(card_index) } if confirmation == MainMenu::YES_ANSWER
  end

  def back_to_menu
    yield if block_given?
    main_menu
  end

  def card_type_input
    outputer.cards_description
    gets.chomp
  end
end
