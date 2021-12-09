require "application_system_test_case"

class EditorTest < ApplicationSystemTestCase
  test "creating new song" do
    visit "/"
    click_on "Add Song"

    fill_in_editor_field file_fixture("drunken-sailor.pro").read

    # Updates preview
    assert_content "Drunken Sailor"
    assert_content "Traditional sea shanty"

    click_button "Save"

    assert_no_css ".ace_editor" # No more editor

    assert_content "Drunken Sailor"
    assert_content "Traditional sea shanty"
    assert_equal 1, Song.count
  end

  test "editing existing song" do
    song = Song.create!(
      title: "Song Name",
      subtitle: "Song Subtitle",
      source: "Song source"
    )

    source = "{t:New Title}\n{st:New Subtitle}\nnew body"
    visit "/"
    click_on song.title
    click_on "Edit"

    fill_in_editor_field(source)

    click_button "Save"
    assert_no_css ".ace_editor" # No more editor

    song.reload
    assert_equal "New Title", song.title
    assert_equal "New Subtitle", song.subtitle
    assert_equal source, song.source
  end

  private

  def fill_in_editor_field(text)
    assert_css ".ace_editor" # wait for editor to appear
    execute_script("editor.setValue(#{text.to_json})")
  end
end
