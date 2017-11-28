//
//  TimelineView.swift
//  Evan Dekhayser
//
//  Created by Evan Dekhayser on 7/25/14.
//  Copyright (c) 2014 Evan Dekhayser. All rights reserved.
//

import UIKit
import AVFoundation
import MealFramework

/**
	Represents an instance in the Timeline. A Timeline is built using one or more of these TimeFrames.
*/
public struct InfoSection{
	/**
		A description of the event.
	*/
	let text: String
	/**
		The info in the frame.
	*/
	let info: String
    
    let image: UIImage?
    
}

public struct InfoOfMeal{
    
    var ingredients: Ingredients
    
    var directions: [Direction]
}


public struct MealAttributes
{
    var carbs: Double
    
    var protein: Double
    
    var fat: Double
}

/**
	The shape of a bullet that appears next to each event in the Timeline.
*/
public enum BulletType{
	/**
		Bullet shaped as a circle with no fill.
	*/
	case Circle
	/**
		Bullet shaped as a hexagon with no fill.
	*/
	case Hexagon
	/**
		Bullet shaped as a diamond with no fill.
	*/
	case Diamond
	/**
		Bullet shaped as a circle with no fill and a horizontal line connecting two vertices.
	*/
	case DiamondSlash
	/**
		Bullet shaped as a carrot facing inward toward the event.
	*/
	case Carrot
	/**
		Bullet shaped as an arrow pointing inward toward the event.
	*/
	case Arrow
}

/**
	View that shows the given events in bullet form.
*/
public class TimelineView : UIView//, UITableViewDelegate, UITableViewDataSource
{
	
	//MARK: Public Properties
	
	/**
		The events shown in the Timeline
	*/
	public var timeFrames: [InfoSection]{
		didSet{
			setupContent()
		}
	}
	
	/**
		The color of the bullets and the lines connecting them.
	*/
	public var lineColor: UIColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1.0){
		didSet{
			setupContent()
		}
	}
	
	/**
		Color of the larger Date title label in each event.
	*/
	public var titleLabelColor: UIColor = UIColor.blackColor(){
		didSet{
			setupContent()
		}
	}
	
	/**
		Color of the smaller Text detail label in each event.
	*/
	public var detailLabelColor: UIColor = UIColor.blackColor(){
		didSet{
			setupContent()
		}
	}
	
	/**
		The type of bullet shown next to each element.
	*/
	public var bulletType: BulletType = BulletType.Circle{
		didSet{
			setupContent()
		}
	}
	
	/**
		If enabled, the timeline shows with the bullet on the right side instead of the left.
	*/
	public var showBulletOnRight: Bool = false{
		didSet{
			setupContent()
		}
	}
    
    public var mealInfo: InfoOfMeal = InfoOfMeal(ingredients: Ingredients(ingredientList: []), directions: []){
        didSet{
            setupContent()
        }
    }
    
    public var mealAttributes: MealAttributes = MealAttributes(carbs: 0, protein: 0, fat: 0)
        {
        didSet{
            setupContent()
        }
    }
    
    var numOfProtein: Double = 27
    var numOfCarbs: Double = 68
    var numOfFat: Double = 49
    
    
    public var commentView: UIView = UIView()
	
	//MARK: Public Methods
	
	/**
		Note that the timeFrames cannot be set by this method. Further setup is required once this initalization occurs.
	
		May require more work to allow this to work with restoration.
	
		@param coder An unarchiver object.
	*/
	required public init?(coder aDecoder: NSCoder) {
		timeFrames = []
		super.init(coder: aDecoder)
	}

	
	/**
		Initializes the timeline with all information needed for a complete setup.
	
		@param bulletType The type of bullet shown next to each element.
	
		@param timeFrames The events shown in the Timeline
	*/
	public init(bulletType: BulletType, timeFrames: [InfoSection]){
		self.timeFrames = timeFrames
		self.bulletType = bulletType
		super.init(frame: CGRect.zero)
		
		translatesAutoresizingMaskIntoConstraints = false
		
		setupContent()
	}
    
	
	//MARK: Private Methods
	
	private func setupContent(){
		for v in subviews{
			v.removeFromSuperview()
		}
		
		let guideView = UIView()
		guideView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(guideView)
		addConstraints([
			NSLayoutConstraint(item: guideView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 24),
			NSLayoutConstraint(item: guideView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: guideView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: guideView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0)
			])
		
		var i = 0
		
		var viewFromAbove = guideView
		
        // MARK: Size of the view
        
		for element in timeFrames{
			let v = blockForTimeFrame(element,mealInfo: mealInfo)
			addSubview(v)
			addConstraints([
				NSLayoutConstraint(item: v, attribute: .Top, relatedBy: .Equal, toItem: viewFromAbove, attribute: .Bottom, multiplier: 1.0, constant: 0),
				NSLayoutConstraint(item: v, attribute: .Width, relatedBy: .Equal, toItem: viewFromAbove, attribute: .Width, multiplier: 1.0, constant: 0),
				])
			if showBulletOnRight{
				addConstraint(NSLayoutConstraint(item: v, attribute: .Right, relatedBy: .Equal, toItem: viewFromAbove, attribute: .Right, multiplier: 1.0, constant: 0))
			} else {
				addConstraint(NSLayoutConstraint(item: v, attribute: .Left, relatedBy: .Equal, toItem: viewFromAbove, attribute: .Left, multiplier: 1.0, constant: 0))
			}
			viewFromAbove = v
			i++
		}
		
		let extraSpace: CGFloat = 200
		
		let line = UIView()
		line.translatesAutoresizingMaskIntoConstraints = false
		line.backgroundColor = lineColor
		addSubview(line)
		sendSubviewToBack(line)
		addConstraints([
			NSLayoutConstraint(item: line, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 1),
			NSLayoutConstraint(item: line, attribute: .Top, relatedBy: .Equal, toItem: viewFromAbove, attribute: .Bottom, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: line, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: extraSpace)
			])
		if showBulletOnRight{
			addConstraint(NSLayoutConstraint(item: line, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1.0, constant: -16.5))
		} else {
			addConstraint(NSLayoutConstraint(item: line, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1.0, constant: 19.5))
		}
		addConstraint(NSLayoutConstraint(item: viewFromAbove, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0))
	}

    private func bulletView(size: CGSize, bulletType: BulletType, image: UIImage?) -> UIView {
        var path: UIBezierPath
        switch bulletType {
        case .Circle:
            path = UIBezierPath(ovalOfSize: size)
        case .Diamond:
            path = UIBezierPath(diamondOfSize: size)
        case .DiamondSlash:
            path = UIBezierPath(diamondSlashOfSize: size)
        case .Hexagon:
            path = UIBezierPath(hexagonOfSize: size)
        case .Carrot:
            path = UIBezierPath(carrotOfSize: size)
        case .Arrow:
            path = UIBezierPath(arrowOfSize: size)
        }

        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.strokeColor = lineColor.CGColor
        shapeLayer.path = path.CGPath

        let v = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.width))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.addSublayer(shapeLayer)
        v.layer.cornerRadius = size.width/2
        
        
        // Add image to the center of the shape layer
        let imgView = UIImageView(image: image)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(imgView)
        v.addConstraints([
            
            NSLayoutConstraint(item: imgView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 12),
            NSLayoutConstraint(item: imgView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 12),
            NSLayoutConstraint(item: imgView, attribute: .CenterX, relatedBy: .Equal, toItem: v, attribute: .CenterX, multiplier: 1.0, constant: 10),
            NSLayoutConstraint(item: imgView, attribute: .CenterY, relatedBy: .Equal, toItem: v, attribute: .CenterY, multiplier: 1.0, constant: 10)
            ])
        
        return v
    }
    
    private func blockForTimeFrame(element: InfoSection,mealInfo: InfoOfMeal) -> UIView{
		let v = UIView()
		v.translatesAutoresizingMaskIntoConstraints = false
		
		//bullet
		let s = CGSize(width: 20, height: 20)
        let bullet: UIView = bulletView(s, bulletType: bulletType,image:element.image)
		v.addSubview(bullet)
		v.addConstraint(NSLayoutConstraint(item: bullet, attribute: .Top, relatedBy: .Equal, toItem: v, attribute: .Top, multiplier: 1.0, constant: 0))

       
        
		if showBulletOnRight{
			v.addConstraint(NSLayoutConstraint(item: bullet, attribute: .Right, relatedBy: .Equal, toItem: v, attribute: .Right, multiplier: 1.0, constant: -24))
		} else {
			v.addConstraint(NSLayoutConstraint(item: bullet, attribute: .Left, relatedBy: .Equal, toItem: v, attribute: .Left, multiplier: 1.0, constant: 10))
		}
		
		let titleLabel = UILabel()
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.font = UIFont.LatoBold(12)
		titleLabel.textColor = titleLabelColor
		titleLabel.text = element.text
		titleLabel.numberOfLines = 0
		titleLabel.layer.masksToBounds = false
		v.addSubview(titleLabel)
		v.addConstraints([
			NSLayoutConstraint(item: titleLabel, attribute: .Width, relatedBy: .Equal, toItem: v, attribute: .Width, multiplier: 1.0, constant: -40),
			NSLayoutConstraint(item: titleLabel, attribute: .Top, relatedBy: .Equal, toItem: v, attribute: .Top, multiplier: 1.0, constant: 2)
			])
		if showBulletOnRight{
			v.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Right, relatedBy: .Equal, toItem: v, attribute: .Right, multiplier: 1.0, constant: -40))
			titleLabel.textAlignment = .Right
		} else {
			v.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Left, relatedBy: .Equal, toItem: v, attribute: .Left, multiplier: 1.0, constant: 40))
			titleLabel.textAlignment = .Left
		}
        
        
        // MARK: Check to see if ingredient section is empty
        
        if(element.text == "INGREDIENTS" && mealInfo.ingredients != [])
        {
            // MARK: Add textview that shows the ingredients
            let textForIngredients = UILabel()
            textForIngredients.translatesAutoresizingMaskIntoConstraints = false
            textForIngredients.sizeToFit()
            textForIngredients.numberOfLines = 0
            textForIngredients.font = UIFont.LatoRegular(12)
            
            for(var i = 0; i <= mealInfo.ingredients.getIngredientList().count; i++)
            {
                textForIngredients.text = mealInfo.ingredients.getIngredientList().joinWithSeparator("\n\n")
            }
            
            v.addSubview(textForIngredients)
            v.addConstraints([
                
                NSLayoutConstraint(item: textForIngredients, attribute: .Right, relatedBy: .Equal, toItem: v, attribute: .Right, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: textForIngredients, attribute: .Top, relatedBy: .Equal, toItem: v, attribute: .Top, multiplier: 1.0, constant: 20),
                NSLayoutConstraint(item: textForIngredients, attribute: .Bottom, relatedBy: .Equal, toItem: v, attribute: .Bottom, multiplier: 1.0, constant: -10)
                
                ])
            
            
            if showBulletOnRight{
                v.addConstraint(NSLayoutConstraint(item: textForIngredients, attribute: .Right, relatedBy: .Equal, toItem: v, attribute: .Right, multiplier: 1.0, constant: -40))
            } else {
                v.addConstraint(NSLayoutConstraint(item: textForIngredients, attribute: .Left, relatedBy: .Equal, toItem: v, attribute: .Left, multiplier: 1.0, constant: 40))
            }
        }
        
        // MARK: Check to see if the is info for the directions sections
        
            if(element.text == "DIRECTIONS" && mealInfo.directions != [] && mealInfo.directions.count+1 != 0)
            {
                let backgroundViewForDirections = UIView()
                backgroundViewForDirections.translatesAutoresizingMaskIntoConstraints = false
                //backgroundViewForDirections.backgroundColor = UIColor.blackColor()
               
                v.addSubview(backgroundViewForDirections)
                
                
                
                
                var y: CGFloat = -2
                
                
                
                
                
                // MARK: Loop to make an ordered list for the directions
                
                
                
                for(var i = 1; i <= mealInfo.directions.count;i++)
                {
                    let textLabelForSteps = UILabel()
                    textLabelForSteps.font = UIFont.LatoBold(20)
                    textLabelForSteps.textAlignment = .Center
                    textLabelForSteps.textColor = UIColor.peachColor()
                    textLabelForSteps.frame = CGRect(x: 0, y: y, width: 30, height: 30)
                    textLabelForSteps.text = String(i)
                    backgroundViewForDirections.addSubview(textLabelForSteps)
                    
                    let textLabelForDirections = UILabel()
                    textLabelForDirections.font = UIFont.LatoRegular(10)
                    textLabelForDirections.numberOfLines = 0
                    textLabelForDirections.frame = CGRect(x: 30, y: y, width: 220, height: 30)
                    textLabelForDirections.text = mealInfo.directions[i-1].getDirectionInfo()
                    textLabelForDirections.sizeToFit()
                    backgroundViewForDirections.addSubview(textLabelForDirections)
                    
                    y += textLabelForDirections.frame.height + 5
                }
                
                v.addConstraints([
                    NSLayoutConstraint(item: backgroundViewForDirections, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 170),
                    NSLayoutConstraint(item: backgroundViewForDirections, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: y),
                    NSLayoutConstraint(item: backgroundViewForDirections, attribute: .Top, relatedBy: .Equal, toItem: titleLabel, attribute: .Bottom, multiplier: 1.0, constant: 5),
                    NSLayoutConstraint(item: backgroundViewForDirections, attribute: .Bottom, relatedBy: .Equal, toItem: v, attribute: .Bottom, multiplier: 1.0, constant: -10)
                    ])
                if showBulletOnRight{
                    v.addConstraint(NSLayoutConstraint(item: backgroundViewForDirections, attribute: .Right, relatedBy: .Equal, toItem: v, attribute: .Right, multiplier: 1.0, constant: -40))
                } else {
                    v.addConstraint(NSLayoutConstraint(item: backgroundViewForDirections, attribute: .Left, relatedBy: .Equal, toItem: v, attribute: .Left, multiplier: 1.0, constant: 40))
                }
  
        }
        
        // MARK : STATISTICS
		if(element.text == "STATISTICS".uppercaseString)
        {
            
            
            let backgroundViewForIngredients = UIView()
            backgroundViewForIngredients.translatesAutoresizingMaskIntoConstraints = false
            v.addSubview(backgroundViewForIngredients)
            v.addConstraints([
                NSLayoutConstraint(item: backgroundViewForIngredients, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 170),
                NSLayoutConstraint(item: backgroundViewForIngredients, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 80),
                NSLayoutConstraint(item: backgroundViewForIngredients, attribute: .Top, relatedBy: .Equal, toItem: titleLabel, attribute: .Top, multiplier: 1.0, constant: 20),
                NSLayoutConstraint(item: backgroundViewForIngredients, attribute: .Bottom, relatedBy: .Equal, toItem: v, attribute: .Bottom, multiplier: 1.0, constant: 50)
                ])
            if showBulletOnRight{
                v.addConstraint(NSLayoutConstraint(item: backgroundViewForIngredients, attribute: .Right, relatedBy: .Equal, toItem: v, attribute: .Right, multiplier: 1.0, constant: -40))
            } else {
                v.addConstraint(NSLayoutConstraint(item: backgroundViewForIngredients, attribute: .Left, relatedBy: .Equal, toItem: v, attribute: .Left, multiplier: 1.0, constant: 40))
            }
            
            var x: CGFloat = 0
            var protein: String = "Protein".uppercaseString
            var carbs: String = "Carbs".uppercaseString
            var fat: String = "Fat".uppercaseString
            
            for (var i = 1; i < 4; i++)
            {
                let statsView: StatisticView = StatisticView(frame: CGRect(x: x, y: 0, width: 90, height: 90))
                
                if (protein == "Protein".uppercaseString)
                {
                    statsView.progressionView.angle = Int(mealAttributes.protein * 3.6)
                    statsView.percentageLabel.text =  String(Int(mealAttributes.protein)) + "%"
                    statsView.textLabel.text = protein
                    backgroundViewForIngredients.addSubview(statsView)
                    protein = ""
                }
                else if (carbs == "Carbs".uppercaseString)
                {
                    statsView.progressionView.angle = Int(mealAttributes.carbs * 3.6)
                    statsView.textLabel.text = carbs
                    statsView.percentageLabel.text = String(Int(mealAttributes.carbs)) + "%"
                    backgroundViewForIngredients.addSubview(statsView)
                    carbs = ""
                }
                else if (fat == "fat".uppercaseString)
                {
                    statsView.progressionView.angle = Int(mealAttributes.fat * 3.6)
                    statsView.textLabel.text = fat
                    statsView.percentageLabel.text = String(Int(mealAttributes.fat)) + "%"
                    backgroundViewForIngredients.addSubview(statsView)
                    fat = ""
                }
                x += statsView.frame.width
                
            }
        }
        
//        // MARK: COMMENTS
//        if (element.text == "COMMENTS".uppercaseString)
//        {
//            
//            let backgroundViewForComments: UIView = UIView()
//            backgroundViewForComments.translatesAutoresizingMaskIntoConstraints = false
//            v.addSubview(backgroundViewForComments)
//            v.addConstraints([
//                NSLayoutConstraint(item: backgroundViewForComments, attribute: .Top, relatedBy: .Equal, toItem: titleLabel, attribute: .Top, multiplier: 1.0, constant: 20),
//                NSLayoutConstraint(item: backgroundViewForComments, attribute: .Bottom, relatedBy: .Equal, toItem: v, attribute: .Bottom, multiplier: 1.0, constant: -10),
//                NSLayoutConstraint(item: backgroundViewForComments, attribute: .Left, relatedBy: .Equal, toItem: v, attribute: .Left, multiplier: 1.0, constant: 30)
//                ])
//            
//            backgroundViewForComments.addSubview(commentView)
//            backgroundViewForComments.addConstraints([
//                
//                NSLayoutConstraint(item: commentView, attribute: .Top, relatedBy: .Equal, toItem: backgroundViewForComments, attribute: .Top, multiplier: 1.0, constant: -10),
//                NSLayoutConstraint(item: commentView, attribute: .Right, relatedBy: .Equal, toItem: backgroundViewForComments, attribute: .Right, multiplier: 1.0, constant: 0),
//                NSLayoutConstraint(item: commentView, attribute: .Bottom, relatedBy: .Equal, toItem: backgroundViewForComments, attribute: .Bottom, multiplier: 1.0, constant: -80)
//                ])
//            
//
//
//        }
        
		
		//draw the line between the bullets
		let line = UIView()
		line.translatesAutoresizingMaskIntoConstraints = false
		line.backgroundColor = lineColor
		v.addSubview(line)
		sendSubviewToBack(line)
		v.addConstraints([
			NSLayoutConstraint(item: line, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 1),
			NSLayoutConstraint(item: line, attribute: .Top, relatedBy: .Equal, toItem: v, attribute: .Top, multiplier: 1.0, constant: 19),
			NSLayoutConstraint(item: line, attribute: .Height, relatedBy: .Equal, toItem: v, attribute: .Height, multiplier: 1.0, constant: -19)
			])
		if showBulletOnRight{
			v.addConstraint(NSLayoutConstraint(item: line, attribute: .Right, relatedBy: .Equal, toItem: v, attribute: .Right, multiplier: 1.0, constant: -16.5))
		} else {
			v.addConstraint(NSLayoutConstraint(item: line, attribute: .Left, relatedBy: .Equal, toItem: v, attribute: .Left, multiplier: 1.0, constant: 19.5))
		}
		
		return v
	}

}

extension UIBezierPath {

    convenience init(hexagonOfSize size: CGSize) {
        self.init()
        moveToPoint(CGPoint(x: size.width / 2, y: 0))
        addLineToPoint(CGPoint(x: size.width, y: size.height / 3))
        addLineToPoint(CGPoint(x: size.width, y: size.height * 2 / 3))
        addLineToPoint(CGPoint(x: size.width / 2, y: size.height))
        addLineToPoint(CGPoint(x: 0, y: size.height * 2 / 3))
        addLineToPoint(CGPoint(x: 0, y: size.height / 3))
        closePath()
    }

    convenience init(diamondOfSize size: CGSize) {
        self.init()
        moveToPoint(CGPoint(x: size.width / 2, y: 0))
        addLineToPoint(CGPoint(x: size.width, y: size.height / 2))
        addLineToPoint(CGPoint(x: size.width / 2, y: size.height))
        addLineToPoint(CGPoint(x: 0, y: size.width / 2))
        closePath()
    }

    convenience init(diamondSlashOfSize size: CGSize) {
        self.init(diamondOfSize: size)
        moveToPoint(CGPoint(x: 0, y: size.height/2))
        addLineToPoint(CGPoint(x: size.width, y: size.height / 2))
    }

    convenience init(ovalOfSize size: CGSize) {
        self.init(ovalInRect: CGRect(origin: CGPointZero, size: size))
    }

    convenience init(carrotOfSize size: CGSize) {
        self.init()
        moveToPoint(CGPoint(x: size.width/2, y: 0))
        addLineToPoint(CGPoint(x: size.width, y: size.height / 2))
        addLineToPoint(CGPoint(x: size.width / 2, y: size.height))
    }

    convenience init(arrowOfSize size: CGSize) {
        self.init(carrotOfSize: size)
        moveToPoint(CGPoint(x: 0, y: size.height/2))
        addLineToPoint(CGPoint(x: size.width, y: size.height / 2))
    }
}
