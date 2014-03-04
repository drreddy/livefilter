class LivefilterController < ApplicationController
  def index
      @data = Movie.all
  end

  def data
    if params['title']
      @result = Movie.where("title = :param",{param: params['title']})
      render json: @result
    elsif params['genre']
      @data = Movie.all
      @result = Array.new()
      x=0
      @data.each do |data|
        @genrelist = data.genre.split(', ')
        if @genrelist.index(params['genre'])
          @result[x] = {"title" => data.title , "link" => data.link , "genre" => data.genre , "year" => data.year , "rating" => data.rating , "runtime" => data.runtime }
          x = x+1
        end
      end
      render json: @result
    elsif params['runtime']
      @result = Movie.where("runtime <= :param",
                  {param: params['runtime']}).order("rating DESC")
      render json: @result
    elsif params['rating']
      @rating = Array.new()
      @rating = params['rating'].split(' - ')
      @result = Movie.where("rating >= :start_rate AND rating <= :end_rate",
                  {start_rate: @rating[0], end_rate: @rating[1]}).order("rating DESC")
      render json: @result
    elsif params['year']
      @year = Array.new()
      @year = params['year'].split(' - ')
      @result = Movie.where("year >= :start_date AND year <= :end_date",
                  {start_date: @year[0], end_date: @year[1]}).order("year ASC")
      render json: @result
    else
      redirect_to root_url
    end
  end

  def adddata
    require 'csv'
  	CSV.foreach(File.dirname(__FILE__) + '/blockbuster.csv', :headers => true) do |row|
      @convert = row.to_hash
      t = Movie.new
  	  	t.title = @convert['title']
  	  	t.director = @convert['director']
        t.link = 'http://www.imdb.com/title/'+@convert['url']+'/'
        t.genre = @convert['genre']
        t.year = @convert['year']
        t.rating = @convert['rating']
        t.runtime = @convert['runtime']
      t.save
    end
    @data = Movie.count
  end
  
  def multidegree
      @data = Movie.all
  end
  
  def multidegreedata
    if params['title'] || params['genre'] || params['runtime'] || params['rating'] || params['year']
      #filter = Array.new
      #filter[0] = "title = ?"
      #filter[0] = filter[0] + " and rating <= ?"
      #filter[1] = params['title']
      #filter[2] = 9.to_s
      query = Array.new
      query[0] = ""

      if params['title']
        query[0] = query[0] + "title = ?"
        query.push(params['title'])
      end

      if params['runtime']
        if query[0] != ""
          query[0] = query[0] + " and runtime <= ?"
          query.push(params['runtime'].to_s)
        else
          query[0] = query[0] + "runtime <= ?"
          query.push(params['runtime'].to_s)
        end
      end

      if params['rating']
        @rating = params['rating'].split(' - ')
        if query[0] != ""
          query[0] = query[0] + " and rating >= ? and rating <= ?"
          query.push(@rating[0].to_s)
          query.push(@rating[1].to_s)
        else
          query[0] = query[0] + "rating >= ? and rating <= ?"
          query.push(@rating[0].to_s)
          query.push(@rating[1].to_s)
        end
      end

      if params['year']
        @year = params['year'].split(' - ')
        if query[0] != ""
          query[0] = query[0] + " and year >= ? and year <= ?"
          query.push(@year[0].to_s)
          query.push(@year[1].to_s)
        else
          query[0] = query[0] + "year >= ? and year <= ?"
          query.push(@year[0].to_s)
          query.push(@year[1].to_s)
        end
      end

      if params['genre']
        if query[0] == ""
          @data = Movie.all
          @result = Array.new()
          x=0
          @data.each do |data|
            @genrelist = data.genre.split(', ')
            if @genrelist.index(params['genre'])
              @result[x] = {"title" => data.title , "link" => data.link , "genre" => data.genre , "year" => data.year , "rating" => data.rating , "runtime" => data.runtime }
              x = x+1
            end
          end
          render json: @result
        else
          @data = Movie.where(query)
          @result = Array.new()
          x=0
          @data.each do |data|
            @genrelist = data.genre.split(', ')
            if @genrelist.index(params['genre'])
              @result[x] = {"title" => data.title , "link" => data.link , "genre" => data.genre , "year" => data.year , "rating" => data.rating , "runtime" => data.runtime }
              x = x+1
            end
          end
          render json: @result
        end
      else
        @result = Movie.where(query)
        render json: @result
      end
    else
      @result = Movie.all
      render json: @result
    end
  end
end
