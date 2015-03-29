# encoding: UTF-8

require 'rubygems'
require 'json'
require 'net/http'
require 'net/https'
require 'zip/zip'

module Echelon
  class DisneylandParis < Park

    attr_reader :json_data

    def ride_list
      {
        'P1AA01' => 'La Cabane des Robinson',
        'P1AA02' => 'Indiana Jones and the Temple of Peril',
        'P1AA04' => 'Pirates of the Caribbean',
        'P1DA03' => 'Autopia',
        'P1DA04' => 'Buzz Lightyear Laser Blast',
        'P1DA06' => 'Les Mystères du Nautilus',
        'P1DA07' => 'Orbitron',
        'P1DA08' => 'Space Mountain: Mission 2',
        'P1DA09' => 'Star Tours',
        'P1DA12' => 'Captain EO',
        'P1NA00' => 'Alice\'s Curious Labyrinth',
        'P1NA01' => 'Blanche-Neige et les Sept Nains',
        'P1NA02' => 'Le Carrousel de Lancelot',
        'P1NA03' => 'Casey Jr. - le Petit Train du Cirque',
        'P1NA05' => 'Dumbo the Flying Elephant',
        'P1NA07' => '"it\'s a small world" Celebration',
        'P1NA08' => 'Mad Hatter\'s Tea Cups',
        'P1NA09' => 'Le Pays des Contes de Fées',
        'P1NA10' => 'Peter Pan\'s Flight',
        'P1NA13' => 'Les Voyages de Pinocchio',
        'P1RA00' => 'Big Thunder Mountain',
        'P1RA03' => 'Phantom Manor',
        'P1RA04' => 'River Rogue Keelboats',
        'P2XA00' => 'Studio Tram Tour: Behind the Magic',
        'P2XA01' => 'CinéMagique',
        'P2XA02' => 'Cars Quatre Roues Rallye',
        'P2XA03' => 'Crush\'s Coaster',
        'P2XA05' => 'Flying Carpets Over Agrabah',
        'P2XA06' => 'RC Racer',
        'P2XA07' => 'Toy Soldiers Parachute Drop',
        'P2XA08' => 'Slinky Dog Zigzag Spin',
        'P2ZA00' => 'Armageddon : les Effets Spéciaux',
        'P2ZA01' => 'Rock\'n\'Roller Coaster starring Aerosmith',
        'P2ZA02' => 'The Twilight Zone Tower of Terror',
        'P2XA09' => 'Ratatouille : L\'Aventure Totalement Toquée de Rémy'
      }
    end

    def initialize
      # fetch the zipped json feed from the same url as the disney iphone app
      # (you have no idea how long this took to work out)

      http = Net::HTTP.new('disney.cms.pureagency.com', 443)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      data = 'key=Ajjjsh;Uj'
      headers = {
        'User-Agent' => 'Disneyland 1.0 (iPhone; iPhone OS 4.1; en_GB)',
        'Content-Type' => 'application/x-www-form-urlencoded;charset=UTF-8'
      }
      resp, _data = http.post('/cms/ProxyTempsAttente', data, headers)

      tmp = Tempfile.new('disneyland_paris_zip')
      tmp << resp.body
      tmp.close

      json_data = nil
      Zip::ZipFile.open(tmp.path) do |zipfile|
        json_data = JSON.parse(zipfile.read('temps_attente.json'))
        json_data = json_data['l']
      end

      i = 0
      rides = []
      while i < json_data.count
        ride = []
        ride << json_data[i]
        ride << json_data[i + 1]
        ride << json_data[i + 2]
        ride << json_data[i + 3]
        ride << json_data[i + 4]
        rides << ride
        i += 5
      end

      @json_data = rides
    end

    private

    def create_ride_object(ref)
      json_data.each do |ride|
        if ride[0] == ref
          return Ride.new(name: ride_list[ref], queue_time: ride[4].to_i, active: ride[3].to_i)
        end
      end
    end
  end
end
