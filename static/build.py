from multiprocessing import Process
from staticjinja import make_site
import easywatch
import os
import shutil

def reset_assets():
    print('Resetting assets...')

    root_path = os.path.dirname(os.path.realpath(__file__))

    html_css = os.path.join(root_path, 'dist/css/')
    html_img = os.path.join(root_path, 'dist/img/')
    html_js = os.path.join(root_path, 'dist/js/')

    tmpl_css = os.path.join(root_path, 'template_assets/css/')
    tmpl_img = os.path.join(root_path, 'template_assets/img/')
    tmpl_js = os.path.join(root_path, 'template_assets/js/')

    if os.path.exists(html_css):
        shutil.rmtree(html_css)

    if os.path.exists(html_img):
        shutil.rmtree(html_img)

    if os.path.exists(html_js):
        shutil.rmtree(html_js)

    shutil.copytree(tmpl_css, html_css)
    shutil.copytree(tmpl_img, html_img)
    shutil.copytree(tmpl_js, html_js)


def asset_handler(event_type, src_path):
    print(src_path[:-4])
    if(src_path[:-4] != ".tmp"):
        dst_path = src_path.replace('/template_assets/', '/dist/')
        print('Updating ' + dst_path)
        shutil.copy(src_path, dst_path)


def watch_assets():
    print('Monitoring assets...')
    easywatch.watch("./template_assets/", asset_handler)


def watch_templates():
    print('Monitoring templates...')

    site = make_site(outpath="dist")
    site.render(use_reloader=True)


if __name__ == "__main__":
    reset_assets()

    asset_monitor = Process(target=watch_assets)
    asset_monitor.start()
    
    tmpl_monitor = Process(target=watch_templates)
    tmpl_monitor.start()    
    