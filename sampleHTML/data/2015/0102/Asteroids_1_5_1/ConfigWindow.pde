import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.event.*;

class ConfigWindow extends JFrame implements ItemListener, ChangeListener, ActionListener
{ 
  // General
  ColorPicker backgroundColor;
  JButton btBackgroundColor = new JButton("Choose");
  
  ColorPicker foregroundColor;
  JButton btForegroundColor = new JButton("Choose");
  
  SpinnerModel mdlLineWidth = new SpinnerNumberModel(Config.General.LineWidth, 1, 5, 1);
  JSpinner spnLineWidth = new JSpinner(mdlLineWidth);

  SpinnerModel mdlGlobalScale = new SpinnerNumberModel(Config.General.GlobalScale, 1, 5, 1);
  JSpinner spnGlobalScale = new JSpinner(mdlGlobalScale);

  JCheckBox chkShowCollisionBounds = new JCheckBox();

  JCheckBox chkShowExplosions = new JCheckBox();
  
  JCheckBox chkShowVelocityVector = new JCheckBox();

  // Ship
  SpinnerModel mdlShipRotationSpeed = new SpinnerNumberModel(Config.Ship.RotationSpeed, 1, 10, 1);
  JSpinner spnShipRotationSpeed = new JSpinner(mdlShipRotationSpeed);

  SpinnerModel mdlShipAcceleration = new SpinnerNumberModel(Config.Ship.Acceleration, 0.001, 5, 0.01);
  JSpinner spnShipAcceleration = new JSpinner(mdlShipAcceleration);

  SpinnerModel mdlShipFireDelay = new SpinnerNumberModel(Config.Ship.FireDelay, 1, 300, 1);
  JSpinner spnShipFireDelay = new JSpinner(mdlShipFireDelay);

  JCheckBox chkShipReactionOnFire = new JCheckBox();

  JCheckBox chkShipCanBeDestroyed = new JCheckBox();

  // Bullet
  SpinnerModel mdlBulletSpeed = new SpinnerNumberModel(Config.Bullet.Speed, 0.5, 10, 0.5);
  JSpinner spnBulletSpeed = new JSpinner(mdlBulletSpeed);

  SpinnerModel mdlBulletLifeSpan = new SpinnerNumberModel(Config.Bullet.LifeSpan, 1, 300, 1);
  JSpinner spnBulletLifeSpan = new JSpinner(mdlBulletLifeSpan);

  JCheckBox chkBulletAddShipVelocity = new JCheckBox();

  // Asteroid
  JCheckBox chkAsteroidAddBulletVelocityOnDestroy = new JCheckBox();

  ConfigWindow()
  {
    super("Configuration Window");
    this.setSize(400, 500);
    getContentPane().setLayout(new GridLayout(4, 1));

    createGeneralPanel();
    createShipPanel();
    createBulletPanel();
    createAsteroidPanel();

    this.setVisible(true);
  }

  private JPanel newGroupBox(String name, GridLayout layout)
  {
    JPanel panel = new JPanel();
    panel.setBorder(BorderFactory.createTitledBorder(name));
    panel.setLayout(layout);

    return panel;
  }

  public void itemStateChanged(ItemEvent e) {
    if (e.getItem()==chkShipReactionOnFire)
      Config.Ship.ReactionOnFire = chkShipReactionOnFire.isSelected();
    else if (e.getItem()==chkBulletAddShipVelocity)
      Config.Bullet.AddShipVelocity = chkBulletAddShipVelocity.isSelected();
    else if (e.getItem()==chkShowCollisionBounds)
      Config.General.ShowCollisionBounds = chkShowCollisionBounds.isSelected();
    else if (e.getItem()==chkShowExplosions)
      Config.General.ShowExplosions = chkShowExplosions.isSelected();
    else if (e.getItem()==chkShowVelocityVector)
      Config.General.ShowVelocityVector = chkShowVelocityVector.isSelected();
    else if (e.getItem()==chkShipReactionOnFire)
      Config.Ship.ReactionOnFire = chkShipReactionOnFire.isSelected();
    else if (e.getItem()==chkShipCanBeDestroyed)
      Config.Ship.CanBeDestroyed = chkShipCanBeDestroyed.isSelected();
    else if (e.getItem()==chkBulletAddShipVelocity)
      Config.Bullet.AddShipVelocity = chkBulletAddShipVelocity.isSelected();
    else if (e.getItem()==chkAsteroidAddBulletVelocityOnDestroy)
      Config.Asteroid.AddBulletVelocityOnDestroy = chkAsteroidAddBulletVelocityOnDestroy.isSelected();
  }
  public void stateChanged(ChangeEvent e) {
    if (e.getSource() == spnGlobalScale)
      Config.General.GlobalScale = Float.parseFloat(spnGlobalScale.getModel().getValue().toString());
    else if (e.getSource() == spnLineWidth)
      Config.General.LineWidth = Float.parseFloat(spnLineWidth.getModel().getValue().toString());
    else if (e.getSource() == spnShipRotationSpeed)
      Config.Ship.RotationSpeed = Float.parseFloat(spnShipRotationSpeed.getModel().getValue().toString());
    else if (e.getSource() == spnShipAcceleration)
      Config.Ship.Acceleration = Float.parseFloat(spnShipAcceleration.getModel().getValue().toString());
    else if (e.getSource() == spnShipFireDelay)
      Config.Ship.FireDelay = Float.parseFloat(spnShipFireDelay.getModel().getValue().toString());
    else if (e.getSource() == spnBulletSpeed)
      Config.Bullet.Speed = Float.parseFloat(spnBulletSpeed.getModel().getValue().toString());  
    else if (e.getSource() == spnBulletLifeSpan)
      Config.Bullet.LifeSpan = Float.parseFloat(spnBulletLifeSpan.getModel().getValue().toString());
  }
  public void actionPerformed(ActionEvent e)
  {
    if (e.getSource() == btBackgroundColor)
    {
      backgroundColor = new ColorPicker();
      backgroundColor.addChangeListener(new ChangeListener()
      {
        public void stateChanged(ChangeEvent e) {
          Config.General.BackgroundColor = backgroundColor.getColor();
        }
      });
    }
    else if (e.getSource() == btForegroundColor)
    {
      foregroundColor = new ColorPicker();
      foregroundColor.addChangeListener(new ChangeListener()
      {
        public void stateChanged(ChangeEvent e) {
          Config.General.ForegroundColor = foregroundColor.getColor();
        }
      });
    }
  }

  private void createGeneralPanel()
  {
    JPanel general = newGroupBox("General", new GridLayout(7, 2));

    general.add(newLabel("Background Color"));
    general.add(btBackgroundColor);
    btBackgroundColor.addActionListener(this);
    
    general.add(newLabel("Foreground Color"));
    general.add(btForegroundColor);
    btForegroundColor.addActionListener(this);

    general.add(newLabel("Line Width"));
    general.add(spnLineWidth);
    spnLineWidth.addChangeListener(this);

    general.add(newLabel("Global Scale"));
    general.add(spnGlobalScale);
    spnGlobalScale.addChangeListener(this);

    general.add(newLabel("Show Collision Bounds"));
    general.add(chkShowCollisionBounds);
    chkShowCollisionBounds.setSelected(Config.General.ShowCollisionBounds);
    chkShowCollisionBounds.addItemListener(this);

    general.add(newLabel("Show Explosions"));
    general.add(chkShowExplosions);
    chkShowExplosions.setSelected(Config.General.ShowExplosions);
    chkShowExplosions.addItemListener(this);

    general.add(newLabel("Show Velocity"));
    general.add(chkShowVelocityVector);
    chkShowVelocityVector.setSelected(Config.General.ShowVelocityVector);
    chkShowVelocityVector.addItemListener(this);

    getContentPane().add(general);
  }
  private void createShipPanel()
  {
    JPanel ship = newGroupBox("Ship", new GridLayout(5, 2));

    ship.add(newLabel("Rotation Speed"));
    ship.add(spnShipRotationSpeed);
    spnShipRotationSpeed.addChangeListener(this);

    ship.add(newLabel("Acceleration"));
    ship.add(spnShipAcceleration);
    spnShipAcceleration.addChangeListener(this);

    ship.add(newLabel("Fire Delay"));
    ship.add(spnShipFireDelay);
    spnShipFireDelay.addChangeListener(this);

    ship.add(newLabel("Reaction on fire"));
    ship.add(chkShipReactionOnFire);
    chkShipReactionOnFire.setSelected(Config.Ship.ReactionOnFire);
    chkShipReactionOnFire.addItemListener(this);

    ship.add(newLabel("Can be destroyed"));
    ship.add(chkShipCanBeDestroyed);
    chkShipCanBeDestroyed.setSelected(Config.Ship.CanBeDestroyed);
    chkShipCanBeDestroyed.addItemListener(this);

    getContentPane().add(ship);
  }
  private void createBulletPanel()
  {
    JPanel bullet = newGroupBox("Bullet", new GridLayout(3, 2));

    bullet.add(newLabel("Speed"));
    bullet.add(spnBulletSpeed);
    spnBulletSpeed.addChangeListener(this);

    bullet.add(newLabel("Life Span"));
    bullet.add(spnBulletLifeSpan);
    spnBulletLifeSpan.addChangeListener(this);

    bullet.add(newLabel("Add Ship Velocity"));
    bullet.add(chkBulletAddShipVelocity);
    chkBulletAddShipVelocity.setSelected(Config.Bullet.AddShipVelocity);
    chkBulletAddShipVelocity.addItemListener(this);

    getContentPane().add(bullet);
  }
  private void createAsteroidPanel()
  {
    JPanel asteroid = newGroupBox("Asteroid", new GridLayout(1, 2));

    asteroid.add(newLabel("Add Bullet Velocity On Destroy"));
    asteroid.add(chkAsteroidAddBulletVelocityOnDestroy);
    chkAsteroidAddBulletVelocityOnDestroy.setSelected(Config.Asteroid.AddBulletVelocityOnDestroy);
    chkAsteroidAddBulletVelocityOnDestroy.addItemListener(this);

    getContentPane().add(asteroid);
  }

  private JLabel newLabel(String caption)
  {
    JLabel label = new JLabel(caption);
    return label;
  }
}

class ColorPicker extends JFrame
{
  JColorChooser jcc = new JColorChooser();
  
  ColorPicker()
  {
    super("Color Picker");

    getContentPane().add(jcc);

    this.pack();
    this.setVisible(true);
  }
  
  public color getColor()
  {
    Color selColor = jcc.getColor();
    return color(selColor.getRed(), selColor.getGreen(), selColor.getBlue(), selColor.getAlpha());
  }
  
  public void addChangeListener(ChangeListener listener)
  {
    jcc.getSelectionModel().addChangeListener(listener);
  }
}

