# == Schema Information
#
# Table name: codecs
#
#  id        :bigint           not null, primary key
#  extension :string           not null
#  mimetype  :string           not null
#
# Indexes
#
#  index_codecs_on_extension  (extension) UNIQUE
#
class CodecSerializer < ActiveModel::Serializer
  attributes :id, :mimetype, :extension
end
