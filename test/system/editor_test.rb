require "application_system_test_case"

class EditorTest < ApplicationSystemTestCase
  test "creating new songsheet" do
    visit new_songsheet_path
    fill_in_editor_field file_fixture('drunken-sailor.pro').read

    # Updates preview
    assert_content "Drunken Sailor"
    assert_content "Traditional sea shanty"

    click_button "Save"

    assert_no_css '.ace_editor' # No more editor

    assert_content "Drunken Sailor"
    assert_content "Traditional sea shanty"
    assert_equal 1, Songsheet.count
  end

  test "editing existing songsheet" do
    songsheet = Songsheet.create!(
      title: "Song Name",
      subtitle: "Song Subtitle",
      source: "Song source"
    )

    source = "{t:New Title}\n{st:New Subtitle}\nnew body"
    visit edit_songsheet_path(songsheet)
    fill_in_editor_field(source)

    click_button "Save"
    assert_no_css '.ace_editor' # No more editor

    songsheet.reload
    assert_equal "New Title", songsheet.title
    assert_equal "New Subtitle", songsheet.subtitle
    assert_equal source, songsheet.source
  end

  private

  def fill_in_editor_field(text)
    execute_script("editor.setValue(#{text.to_json})")
    # find_ace_editor_field.send_keys text
  end
end
