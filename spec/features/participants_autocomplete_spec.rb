require 'spec_helper'

feature 'Member autocomplete', :js do
  let(:project) { create(:project, :public) }
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:note) { create(:note, noteable: noteable, project: noteable.project) }

  before do
    note # actually create the note
    login_as(user)
  end

  shared_examples "open suggestions when typing @" do
    before do
      page.within('.new-note') do
        find('#note_note').send_keys('@')
      end
    end

    it 'suggests noteable author and note author' do
      page.within('.atwho-view', visible: true) do
        expect(page).to have_content(author.username)
        expect(page).to have_content(note.author.username)
      end
    end
  end

  context 'adding a new note on a Issue' do
    let(:noteable) { create(:issue, author: author, project: project) }
    before do
      visit namespace_project_issue_path(project.namespace, project, noteable)
    end

    include_examples "open suggestions when typing @"
  end

  context 'adding a new note on a Merge Request' do
    let(:noteable) do
      create(:merge_request, source_project: project,
                             target_project: project, author: author)
    end
    before do
      visit namespace_project_merge_request_path(project.namespace, project, noteable)
    end

    include_examples "open suggestions when typing @"
  end

  context 'adding a new note on a Commit' do
    let(:noteable) { project.commit }
    let(:note) { create(:note_on_commit, project: project, commit_id: project.commit.id) }

    before do
      allow_any_instance_of(Commit).to receive(:author).and_return(author)

      visit namespace_project_commit_path(project.namespace, project, noteable)
    end

    include_examples "open suggestions when typing @"
  end
end