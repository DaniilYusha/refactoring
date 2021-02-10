class Account
  attr_reader :name, :age, :login, :password, :cards, :errors

  LOGIN_LENGTH = (4..20).freeze
  PASSWORD_LENGTH = (6..30).freeze
  AGE_RANGE = (23..90).freeze

  def initialize(name:, age:, login:, password:)
    @name = name
    @age = age
    @login = login
    @password = password
    @cards = []
    @errors = []
  end

  def destroy
    new_accounts = FileLoader.load_accounts.delete_if { |account| account.login == login }
    FileLoader.save new_accounts
    exit
  end

  def add_card(card_type)
    cards << Object.const_get(card_type.capitalize + 'Card').new(self)
    AccountManager.update self
  end

  def destroy_card(card_index)
    cards.delete_at(card_index.to_i - 1)
    AccountManager.update self
  end

  def valid?
    validate!
    errors.empty?
  end

  private

  def validate!
    validate_name
    validate_login
    validate_password
    validate_age
  end

  def validate_name
    errors << I18n.t('errors.name.first_upcase_letter') if name.strip.empty? || name[0].upcase != name[0]
  end

  def validate_login
    errors << I18n.t('errors.login.not_empty') if login.strip.empty?
    errors << I18n.t('errors.login.longer_than', min_length: LOGIN_LENGTH.first) if login.length < LOGIN_LENGTH.first
    errors << I18n.t('errors.login.shorter_than', max_length: LOGIN_LENGTH.last) if login.length > LOGIN_LENGTH.last
    errors << I18n.t('errors.login.account_exists') if AccountManager.exists_with_login? login
  end

  def validate_password
    errors << I18n.t('errors.password.not_empty') if password.strip.empty?
    errors << I18n.t('errors.password.longer', min: PASSWORD_LENGTH.first) if password.length < PASSWORD_LENGTH.first
    errors << I18n.t('errors.password.shorter', max: PASSWORD_LENGTH.last) if password.length > PASSWORD_LENGTH.last
  end

  def validate_age
    errors << I18n.t('errors.age.range', min: AGE_RANGE.first, max: AGE_RANGE.last) unless AGE_RANGE.include? age
  end
end
