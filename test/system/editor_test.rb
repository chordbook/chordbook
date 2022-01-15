require "application_system_test_case"

class EditorTest < ApplicationSystemTestCase
  test "creating new song" do
    visit "/songsheets/new"
    assert_no_js_errors

    fill_in_editor_field file_fixture("drunken-sailor.pro").read

    # Updates preview
    assert_content "Drunken Sailor"
    assert_content "Traditional sea shanty"

    click_button "Save"
    assert_no_js_errors

    assert_no_css ".ace_editor" # No more editor

    assert_content "Drunken Sailor"
    assert_content "Traditional sea shanty"
    assert_equal 1, Songsheet.count
  end

  test "editing existing song" do
    songsheet = Songsheet.create!(
      title: "Song Name",
      metadata: {subtitle: "Song Subtitle"},
      source: "Song source"
    )

    source = "{t:New Title}\n{st:New Subtitle}\nnew body"
    visit "/songsheets"
    click_on songsheet.title
    click_on "Edit"

    fill_in_editor_field(source)
    assert_no_js_errors

    click_button "Save"
    assert_no_css ".ace_editor" # No more editor

    songsheet.reload
    assert_equal "New Title", songsheet.title
    assert_equal "New Subtitle", songsheet.metadata["subtitle"]
    assert_equal source, songsheet.source
    assert_no_js_errors
  end

  private

  def fill_in_editor_field(text)
    assert_css ".ace_editor" # wait for editor to appear
    execute_script("editor.setValue(#{text.to_json})")
  end
end
