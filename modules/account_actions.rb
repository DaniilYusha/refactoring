module AccountActions
  def destroy_account
    outputer.destroy_account
    current_account.destroy if gets.chomp == MainMenu::YES_ANSWER
  end
end
