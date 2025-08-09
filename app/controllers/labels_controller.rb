class LabelsController < ApplicationController
  before_action :set_label, only: %i[show update destroy merge]

  def index
    authorize Label
    @labels = apply_scopes(policy_scope(Label))
              .order(id: :asc)
              .paginate(page: params[:page], per_page: params[:per_page])
    add_pagination_headers(@labels)

    render json: @labels.map { transform_label_for_json(it) }
  end

  def show
    render json: transform_label_for_json(@label)
  end

  def create
    authorize Label
    @label = Label.new(permitted_attributes(Label))

    if @label.save
      render json: transform_label_for_json(@label), status: :created
    else
      render json: @label.errors, status: :unprocessable_content
    end
  end

  def update
    if @label.update(permitted_attributes(@label))
      render json: transform_label_for_json(@label), status: :ok
    else
      render json: @label.errors, status: :unprocessable_content
    end
  end

  def destroy
    render json: @label.errors, status: :unprocessable_content unless @label.destroy
  end

  def destroy_empty
    authorize Label
    Label.where.not(id: AlbumLabel.select(:label_id).distinct).destroy_all
  end

  def merge
    @label.merge(Label.find(params[:source_id]))
    # We don't do error handling here. The merge action isn't supposed to fail.
    render json: transform_label_for_json(@label), status: :ok
  end

  private

  def set_label
    @label = Label.find(params[:id])
    authorize @label
  end

  def transform_label_for_json(label)
    %i[id name normalized_name].index_with { label.send(it) }
  end
end
