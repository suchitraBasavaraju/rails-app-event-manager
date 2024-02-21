require "application_system_test_case"
class EndToEndTest < ApplicationSystemTestCase

  test "Event A creation" do
    user = User.create(email: "test1@test.com",password: "password",password_confirmation: "password")
    visit root_url
    assert_text "Login"

    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_on "Log in"

    assert page.has_text?(user.email)
    assert_text "Signed in successfully"

    click_on "Create Event A"
    assert_text "Event A sent"
  end

  test "Event B creation" do
    user = User.create(email: "test2@test.com",password: "password",password_confirmation: "password")
    visit root_url
    assert_text "Login"

    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_on "Log in"

    assert page.has_text?(user.email)
    assert_text "Signed in successfully"

    click_on "Create Event B"
    assert_text "Event B sent - Email Notification sent"
  end
end