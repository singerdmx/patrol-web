module FactoriesHelper
  include ApplicationHelper

  def index_ui_json_builder(factories_json)
    results = []
    factories_json.each do |factory|
      ui_factory = {}
      ui_factory[:id] = factory['id']
      ui_factory[:kind] = 'factory'
      ui_factory[:icon] = factory['subfactories'].empty? ? 'blank.png' : 'minus.png'
      ui_factory[:title] = '工厂'
      ui_factory[:description] = factory['name']
      ui_factory[:children] = ui_subfactories(factory['subfactories'])
      results << ui_factory
    end

    results
  end

  private

  def ui_subfactories(subfactories)
    results = []
    subfactories.each do |subfactory|
      ui_subfactory = {}
      ui_subfactory[:id] = subfactory['id']
      ui_subfactory[:kind] = 'subfactory'
      ui_subfactory[:icon] = subfactory['areas'].empty? ? 'blank.png' : 'minus.png'
      ui_subfactory[:title] = '分厂'
      ui_subfactory[:description] = subfactory['name']
      ui_subfactory[:children] = ui_areas(subfactory['areas'])
      results << ui_subfactory
    end

    results
  end

  def ui_areas(areas)
    results = []
    areas.each do |area|
      ui_area = {}
      ui_area[:id] = area['id']
      ui_area[:kind] = 'area'
      ui_area[:icon] = 'location.png'
      ui_area[:title] = '工区'
      ui_area[:description] = area['name']
      ui_area[:children] = []
      results << ui_area
    end

    results
  end
end
