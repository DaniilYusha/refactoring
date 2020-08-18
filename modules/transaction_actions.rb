module TransactionActions
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

  def handle_transaction(operation)
    back_to_menu { outputer.no_cards } unless current_account.cards.any?
    outputer.show_cards_list current_account.cards, I18n.t("#{operation}.choose_card")
    answer = gets.chomp
    back_to_menu if answer == MainMenu::EXIT_COMMAND
    back_to_menu { outputer.wrong_number operation } unless answer.to_i.between?(1, current_account.cards.length)
    card = current_account.cards[answer.to_i - 1]

    yield card
  end

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
    back_to_menu { outputer.no_recipient_card recipient_number } if AccountManager.find_card(recipient_number).nil?
    AccountManager.find_card recipient_number
  end
end
