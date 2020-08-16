class BaseCard
  attr_reader :number, :type, :balance, :account

  CARD_LENGTH = 16

  def initialize(account)
    @account = account
    @number = generate_card_number
  end

  def put_money(amount)
    @balance += amount - put_tax(amount)
    AccountManager.update account
  end

  def withdraw_money(amount)
    @balance -= amount - withdraw_tax(amount)
    AccountManager.update account
  end

  def send_money(amount, recipient_card)
    @balance -= amount - sender_tax(amount)
    recipient_card.put_money amount
    AccountManager.update account
  end

  def enough_money_for_put?(amount)
    (balance + amount - put_tax(amount)).positive?
  end

  def enough_money_for_withdraw?(amount)
    (balance - amount - withdraw_tax(amount)).positive?
  end

  def enough_money_for_send?(amount)
    (balance - amount - sender_tax(amount)).positive?
  end

  private

  def generate_card_number
    16.times.map { rand(10) }.join
  end

  def tax(amount, percent, fixed)
    amount * percent / 100.0 + fixed
  end

  def withdraw_percent
    0
  end

  def withdraw_fixed
    0
  end

  def put_percent
    0
  end

  def put_fixed
    0
  end

  def sender_percent
    0
  end

  def sender_fixed
    0
  end
end
