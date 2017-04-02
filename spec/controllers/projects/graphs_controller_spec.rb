require 'spec_helper'

describe Projects::GraphsController do
  let(:project) { create(:project, :repository) }
  let(:user)    { create(:user) }

  before do
    sign_in(user)
    project.team << [user, :master]
  end

  describe 'GET languages' do
    it "redirects_to action charts" do
      get(:commits, namespace_id: project.namespace.path, project_id: project.path, id: 'master')

      expect(response).to redirect_to action: :charts
    end
  end

  describe 'GET commits' do
    it "redirects_to action charts" do
      get(:commits, namespace_id: project.namespace.path, project_id: project.path, id: 'master')

      expect(response).to redirect_to action: :charts
    end
  end

  describe 'GET charts' do
    let(:linguist_repository) do
      double(languages: {
               'Ruby'         => 1000,
               'CoffeeScript' => 350,
               'NSIS'         => 15
             })
    end

    let(:expected_values) do
      nsis_color = "##{Digest::SHA256.hexdigest('NSIS')[0...6]}"
      [
        # colors from Linguist:
        { label: "Ruby",         color: "#701516",  highlight: "#701516" },
        { label: "CoffeeScript", color: "#244776",  highlight: "#244776" },
        # colors from SHA256 fallback:
        { label: "NSIS",         color: nsis_color, highlight: nsis_color }
      ]
    end

    before do
      allow(Linguist::Repository).to receive(:new).and_return(linguist_repository)
    end

    it 'sets the correct colour according to language' do
      get(:charts, namespace_id: project.namespace, project_id: project, id: 'master')

      expected_values.each do |val|
        expect(assigns(:languages)).to include(a_hash_including(val))
      end
    end
  end
end
