require 'sinatra'
require 'mongoid'
require 'json'

# this is the mongoid setup
require 'pony'
require 'highline/import'

Mongoid.load!("mongoid.yml", :development)


class Visitor
    include Mongoid::Document

    field :name
    field :place
    field :email
    
end


#so here you put the sinatra app... 
#to display the signup form go here...

get '/' do
    erb :form
    
end

post '/' do
    @name = params[:visitor_name].capitalize
    @place = params[:place].capitalize
    @mood = params[:mood]
    @recomendation = params[:fav]
    #@museum = museum
    #@finalText = finalText
    
 
# musum advice
def museum
if  @mood == 'stressed'
    return "If you are stressed, one of the more relaxed days out can be found just north of Oxford street in the Wallace collection. It's a medium sized historic house with the most sumptuous decoration and a slow atmosphere. Ask about the 
            intricate history of the Serve porceline and the delicate furniture, some of which belonged to Mary Antoinette."
elsif  @mood =='contemplative'
        return "A wonder around the National Gallery is always rewarding. As National Art collections go this one is not too big, and so it is easy to walk around the majority of it without getting 'art sick'.
         However, may be small compared to places like the met but it sure is packed with mazing masterpeices."

elsif @mood =='inspired'
    return "Take a sketch book to the V+A and try sketching some of your favourite peices. Dont spend more 
    than 10 minites on each one, constantly move around the objects seeing them from different angles. 
    Use only a limited amount of colours to push your skills"
    
else @mood =='bored'
    return "A trip to Brick Lane will always shake the dust from the creative cobwwebs! 
    Wander around he shops and markets studying the graffitti, which constantly changes.
     Admire the street signs whilst munching of a delicious curry before redesigning your wardrobe in the 
     fantastic vintage shops!"
                
end
end

# object advice! 
#walace collection
def finalText
    if @mood == 'stressed' && @recomendation == 'colour'
         @finalText = "absorb the amazing colours of the French Rococo era, from the dazzling wallpaper to the sumptous still lives in the main gallery"
    elsif @mood == 'stressed' && @recomendation == 'concepts'
        @finalText = "Study the still lifes in th long gallery, through this link (here) try and work out exactly why
         each object may have been chosen for the painting. Deconstruct the image to discover more about the patron."
    elsif @mood == 'stressed' && @recomendation == 'icons'
        @finalText = "find the Fragonard's 'The Swing' on the first floor; try and work out exactly who this painting was created for  why, 
        what is the purpose of the dog and the man in he bushes?"
    elsif @mood == 'stressed' && @recomendation == 'unknown'
        @finalText = "check out the amazing collection of armour in the lower gallerys, 
        try and imagine wearing one of those suits day in dayout walking hundreds of miles to battle"



# national gallery
elsif @mood =='contemplative' && @recomendation =='colour'
    @finalText = "the impressionist work, on the first floor to the right as you walk in the main entrance, 
    or Turner's 'Rain, Steam and Speed' in room 39."
elsif @mood =='contemplative' && @recomendation == 'concepts'
    @finalText = "study the pre-renaissance style of painting in the Sainsbury wing, 
    ask the attendents about the visual consequences of the workshop practice. 
    In particular look at the Wilton Dyptych"
elsif @mood == 'contemplative' && @recomendation =='icons'
    @finalText = "with out a doubt pay a visit to Leonardo da Vinci's 
    'Madonna on the Rocks', arguably on of the finest works in the collection"


# v+a
elsif @mood == 'inspired' && @recomendation == 'colour'
    @finalText = "admire the fantastic glass scultpture by Chihuly in the entrance hall.
     His Rotunda Chandelier was made for the gallery in 2001 and constructed entirely of blown glass. 
     Each peice is secured individually to the center, it is 27 ft tall and weight in at 3800lb.

     

     The glass collections are wonderful, from modern peices to medieval stained glass the colours radiating in the galleries
     are enough to send the veiwer into raptures. Try and find the fabled Luck of Edenhall in the glass gallery, a beautiful
     cup brimming with tales and myths. "
elsif @mood =='inspired' && @recomendation == 'concepts'
    @finalText = "Go to the Islamic Middle East galleries on the ground floor to look at the amazing art from the Middle East and North Africa. 
    Ranging from the 7th to the 20th century some of the patterns are equisit in detail and colour. 
    Compare the development of visual culture of the East with that of the more famous Itaian Renaissance in the West."
elsif @mood == 'inspired' && @recomendation =='icons'
    @finalText = "check out the fashion displays. As a museum of Art and Design the fashion collection spans 100 years, you can see everything from the bustles 
    of Victorian London to the costumes of modern rock legends such as David Bowie. Visit room 40 to see the Fashion Gallery, spaning 1750 to the present"
elsif @mood == 'inspired' && @recomendation =='unknown'
    @finalText = "The Jewellery Gallery (rooms 91-93) on he first floor a hidden gem, literally. Even if your not often excited by 
    large pretty stones this collection will have you dancing on your heels. Imagine wearing the Tiara in case 17, room 91!"


# brick lane

elsif @mood == 'bored' && @recomendation == 'colour'
    @finalText = "wander around and admire the colours and smells of the world convieniently in one street. 
    Brick Lane has some of the best street food in the UK with unbeatable curries."
elsif @mood =='bored' && @recomendation == 'concepts'
    @finalText = "Theres always interesting art displays on in the small gallerieis and shops, 
    but they move around. Go for an explore and record what you see."
elsif @mood == 'bored' && @recomendation =='icons'
    @finalText = "Check out the graffiti, it changes weekly and always has something beutiful to offer"
else @mood == 'bored' && @recomendation =='unknown'
    @finalText = "try finding the biegle shop for a really good, cheap bagel. 
    Throw in a portugese custard tart for 75p to, one of the most reasnable prices in London!"
end
end

    n = Visitor.new(:name => @name, :place => @place)
    n.save

    #this took the users input and saved it to the database
    #pony

    erb:result
    #getting up the thanks page

end
#to keep a record of everyone who has visited

get '/list' do
    puts 'hello-world'
    @visitor = Visitor.all
    erb :records
end

post '/result' do 

    vemail = params[:email]
    d = Visitor.new(:email => vemail)

     Pony.mail(:to => vemail, 
        :subject => "The amazing mini-meandering machine", :body => erb(:email, :layout => false))
    erb:thanks
end

#for email
 Pony.options = { 
  :via => 'smtp',
  :via_options => {
      :address              => 'smtp.gmail.com',
      :port                 => '587',
      :enable_starttls_auto => true,
      :user_name            => ENV['USER_NAME'],
      :password             => ENV['PASSWORD'],
      :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
      :domain               => "localhost.localdomain" # the HELO domain provided by the client to the server
    }
  }