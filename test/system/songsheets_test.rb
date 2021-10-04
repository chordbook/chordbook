require "application_system_test_case"

class SongsheetsTest < ApplicationSystemTestCase
  setup do
    @songsheet = songsheets(:one)
  end

  test "visiting the index" do
    visit songsheets_url
    assert_selector "h1", text: "Songsheets"
  end

  test "creating a Songsheet" do
    visit songsheets_url
    click_on "New Songsheet"

    fill_in "Body", with: @songsheet.body
    click_on "Create Songsheet"

    assert_text "Songsheet was successfully created"
    click_on "Back"
  end

  test "updating a Songsheet" do
    visit songsheets_url
    click_on "Edit", match: :first

    fill_in "Body", with: @songsheet.body
    click_on "Update Songsheet"

    assert_text "Songsheet was successfully updated"
    click_on "Back"
  end

  test "destroying a Songsheet" do
    visit songsheets_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Songsheet was successfully destroyed"
  end
end
