# coding: utf-8

class DummyController < ApplicationController
  def a
    json = { comment: 'あああ' }
    render json: json, status: :ok
  end

  def b
    json = {}
    render json: json, status: :ok
  end

  def c
    json = { timestamp: Time.now.strftime('%Y-%m-%d %H:%M:%S') }
    render json: json, status: :ok
  end
end
