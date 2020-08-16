class VirtualCard < BaseCard
  def initialize(account)
    super

    @type = 'virtual'
    @balance = 150.00
  end

  def withdraw_tax(amount)
    tax(amount, withdraw_percent, withdraw_fixed)
  end

  def put_tax(amount)
    tax(amount, put_percent, put_fixed)
  end

  def sender_tax(amount)
    tax(amount, sender_percent, sender_fixed)
  end

  private

  def withdraw_percent
    88
  end

  def put_fixed
    1
  end

  def sender_fixed
    1
  end
end
