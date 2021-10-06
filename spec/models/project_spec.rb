require 'rails_helper'

RSpec.describe Project, type: :model do
  it "does not allow duplicate project names per user" do
    user = FactoryBot.create(:user)

    user.projects.create(name: 'Test project')
    new_project = user.projects.build(name: 'Test project')
    new_project.valid?
    expect(new_project.errors[:name]).to include('has already been taken')
  end

  it 'allows two users to share a project name' do
    user = FactoryBot.create(:user)
    user.projects.create(name: 'Test project')

    other_user = FactoryBot.create(:user, first_name: 'Jane', last_name: 'Tester')
    other_project = other_user.projects.build(name: 'Test project')

    expect(other_project).to be_valid
  end

  it 'can have many notes' do
    project = FactoryBot.create(:project, :with_notes)
    expect(project.notes.length).to eq 5
  end

  describe 'late status' do
    it 'is late when the due date is past today' do
      project = FactoryBot.create(:project, :project_due_yesterday)
      expect(project).to be_late
    end

    it 'is on time when the due date is today' do
      project = FactoryBot.create(:project, :project_due_tody)
      expect(project).to_not be_late
    end

    it 'is on time when the due date is in the future' do
      project = FactoryBot.create(:project, :project_due_tomorrow)
      expect(project).to_not be_late
    end
  end
end
