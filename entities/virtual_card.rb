class VirtualCard < BaseCard
  def initialize(account)
    super

    @type = 'virtual'
    @balance = 150.00
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
