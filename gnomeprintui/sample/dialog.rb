#!/usr/bin/env ruby

require "gnomeprintui2"

class Renderer
  def initialize
    @job = Gnome::PrintJob.new
    @context = @job.context
    @config = @job.config
    init_setting
    draw
    @job.close
  end
  
  def print
    @job.print
  end

  def preview
    prev = Gnome::PrintJobPreview.new(@job, "preview")
    prev.show_all
    prev.signal_connect("unrealize") {Gtk.main_quit}
    Gtk.main
  end
  
  def dialog
    args = [@job, "preview", Gnome::PrintDialog::RANGE]
    dialog = Gnome::PrintDialog.new(*args)
    response = dialog.run
    dialog.destroy
    case response
    when Gnome::PrintDialog::RESPONSE_PRINT
      print
    when Gnome::PrintDialog::RESPONSE_PREVIEW
      preview
    when Gnome::PrintDialog::RESPONSE_CANCEL
      puts "canceled"
    else
      puts "???"
    end
  end
  
  private
  def init_setting
    key = Gnome::PrintConfig::KEY_DOCUMENT_NAME
    @config[key] = "Sample Ruby/GnomePrintUI document"
  end

  def draw
    @context.begin_page("1")
    draw_line
    draw_rectangle
    draw_arc
    draw_curve
    draw_text
    draw_pango
    draw_image
    @context.show_page
  end

  def draw_line
    @context.move_to(100, 100)
    @context.line_to(200, 200)
    @context.stroke
    @context.line_stroked(100, 500, 200, 200)
    # @context.line_stroked(200, 200, 100, 500)
  end

  def draw_rectangle
    @context.rect_stroked(200, 200, 100, 100)
    @context.rect_filled(200, 300, 100, 100)
  end

  def draw_arc
    @context.arc_to(50, 450, 10, 0, 90, 1)
    @context.stroke
    @context.save do
      @context.set_rgb_color(255, 0, 0)
      @context.set_opacity(0.7)
      @context.arc_to(40, 450, 10, 0, 359, 0)
      @context.fill
    end
    @context.arc_to(40, 450, 10, 0, 359, 0)
    @context.stroke
  end

  def draw_curve
    @context.move_to(50, 300)
    @context.curve_to(20, 400, 20, 500, 50, 600)
    @context.stroke
  end
  
  def draw_text
    @context.move_to(100, 50)
    @context.show("abcde")
  end
  
  def draw_pango
    @context.move_to(350, 350)
    layout = @context.create_layout
    layout.text = "Pango"
    layout.context_changed
    @context.layout(layout)
  end

  def draw_image
    filename = Dir["**/*.png"].first
    pixbuf = Gdk::Pixbuf.new(filename)
    @context.save do
      @context.translate(350, 500)
      @context.scale(pixbuf.width, pixbuf.height)
      args = [pixbuf.pixels, pixbuf.width, pixbuf.height, pixbuf.rowstride]
      if pixbuf.has_alpha?
        @context.rgba_image(*args)
      else
        @context.rgb_image(*args)
      end
    end
  end
  
end

Gtk.init

Renderer.new.dialog
