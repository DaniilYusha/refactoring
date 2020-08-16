module CardActions
  CARDS_TYPES = I18n.t(:cards_types).values

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

  def put_money
    operation = __method__.to_s
    handle_transaction(operation) do |card|
      amount = amount_input operation
      back_to_menu { outputer.tax_is_higher operation } if card.put_tax(amount) >= amount
      complete_transaction operation: operation, amount: amount, card: card
    end
  end

  def withdraw_money
    operation = __method__.to_s
    handle_transaction(operation) do |card|
      amount = amount_input operation
      back_to_menu { outputer.no_enough_money operation } unless card.enough_money_for_withdraw?(amount)
      complete_transaction operation: operation, amount: amount, card: card
    end
  end

  def send_money
    operation = __method__.to_s
    handle_transaction(operation) do |card|
      recipient_card = recipient_card_input
      amount = amount_input operation
      back_to_menu { outputer.no_enough_money operation } unless card.enough_money_for_send?(amount)
      back_to_menu { outputer.tax_is_higher operation } unless recipient_card.enough_money_for_put?(amount)
      complete_transaction operation: operation, amount: amount, card: card, recipient_card: recipient_card
    end
  end

  private

  def complete_transaction(operation:, amount:, card:, recipient_card: nil)
    return put_or_withdraw_result(operation, amount, card) unless operation.include?('send')

    send_result amount, card, recipient_card
  end

  def put_or_withdraw_result(operation, amount, card)
    action = operation.delete_suffix '_money'
    card.public_send operation, amount
    outputer.public_send "money_#{action}", amount, card
  end

  def send_result(amount, card, recipient_card)
    card.send_money amount, recipient_card
    outputer.money_send amount, card, recipient_card
  end

  def confirm_destroying_card(card_index)
    outputer.confirm_destroying_card current_account.cards[card_index.to_i - 1].number
    confirmation = gets.chomp
    back_to_menu { current_account.destroy_card(card_index) } if confirmation == MainMenu::YES_ANSWER
  end

  def handle_transaction(operation)
    back_to_menu { outputer.no_cards } unless current_account.cards.any?
    outputer.show_cards_list current_account.cards, I18n.t("#{operation}.choose_card")
    answer = gets.chomp
    back_to_menu if answer == MainMenu::EXIT_COMMAND
    back_to_menu { outputer.wrong_number operation } unless answer.to_i.between?(1, current_account.cards.length)
    card = current_account.cards[answer.to_i - 1]

    yield card
  end

  def back_to_menu
    yield if block_given?
    main_menu
  end

  def card_type_input
    outputer.cards_description
    gets.chomp
  end

  def amount_input(operation)
    outputer.prompt_input_amount operation
    amount = gets.chomp.to_i
    back_to_menu { outputer.incorrect_amount operation } unless amount.positive?
    amount
  end

  def recipient_card_input
    outputer.enter_recipient_card
    recipient_number = gets.chomp
    back_to_menu { outputer.incorrect_card } unless recipient_number.length == BaseCard::CARD_LENGTH
    back_to_menu { outputer.no_recipient_card recipient_number } unless AccountManager.card_exists?(recipient_number)
    AccountManager.find_card recipient_number
  end
end
