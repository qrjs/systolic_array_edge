#!/usr/bin/env python3
"""Build a short group-meeting deck for the current project status.

This deck intentionally excludes the functional-coverage section and focuses on:
1. Thesis framing and current experiment scope
2. Unified 4x4 dataflow platform progress
3. Edge-oriented RTL optimizations for DiP
4. Current regression / synthesis snapshot
5. Next backend and thesis steps
"""

from __future__ import annotations

import argparse
import subprocess
import time
from pathlib import Path

import uno
from com.sun.star.awt import Point, Size
from com.sun.star.beans import PropertyValue


SLIDE_W = 28000
SLIDE_H = 15750

FONT = "Noto Sans CJK SC"
TITLE_SIZE = 24
SECTION_SIZE = 22
BODY_SIZE = 14
SMALL_SIZE = 10.5
BIG_METRIC_SIZE = 26
MID_METRIC_SIZE = 18

BG = 0xF7F8FA
NAVY = 0x17324D
NAVY_2 = 0x2A5B84
TEAL = 0x3B8C88
GREEN = 0x6AA87D
ORANGE = 0xE68642
GOLD = 0xD9A441
INK = 0x22313F
MUTED = 0x596A79
WHITE = 0xFFFFFF
CARD = 0xEEF3F7
CARD_2 = 0xEDF5F2
CARD_3 = 0xFFF4EA
CARD_4 = 0xF5F0FA
LINE = 0xD3DDE6


def mm(value: float) -> int:
    return int(round(value * 100))


def make_prop(name: str, value) -> PropertyValue:
    prop = PropertyValue()
    prop.Name = name
    prop.Value = value
    return prop


def file_url(path: Path) -> str:
    return uno.systemPathToFileUrl(str(path.resolve()))


def bullet_lines(lines: list[str]) -> str:
    return "\n".join(f"• {line}" for line in lines)


def add_rect(doc, page, x, y, w, h, fill, line=None, radius=180, line_width=0):
    shape = doc.createInstance("com.sun.star.drawing.RectangleShape")
    shape.setPosition(Point(x, y))
    shape.setSize(Size(w, h))
    shape.FillColor = fill
    shape.LineColor = fill if line is None else line
    shape.LineWidth = line_width
    shape.CornerRadius = radius
    page.add(shape)
    return shape


def add_text(
    doc,
    page,
    x,
    y,
    w,
    h,
    text,
    size,
    color=INK,
    *,
    bold=False,
    font=FONT,
):
    shape = doc.createInstance("com.sun.star.drawing.TextShape")
    shape.setPosition(Point(x, y))
    shape.setSize(Size(w, h))
    shape.String = text
    shape.CharFontName = font
    shape.CharHeight = size
    shape.CharColor = color
    if bold:
        shape.CharWeight = 150.0
    shape.TextLeftDistance = mm(1.2)
    shape.TextRightDistance = mm(1.0)
    shape.TextUpperDistance = mm(0.8)
    shape.TextLowerDistance = mm(0.6)
    page.add(shape)
    return shape


def clear_page(page) -> None:
    while page.getCount() > 0:
        page.remove(page.getByIndex(0))


def get_slide(doc, index: int):
    pages = doc.getDrawPages()
    while pages.getCount() <= index:
        pages.insertNewByIndex(pages.getCount())
    page = pages.getByIndex(index)
    clear_page(page)
    return page


def decorate_standard_slide(doc, page, title: str, tag: str | None = None) -> None:
    add_rect(doc, page, 0, 0, SLIDE_W, SLIDE_H, BG, radius=0)
    add_rect(doc, page, 0, 0, SLIDE_W, mm(18), NAVY, radius=0)
    add_text(doc, page, mm(10), mm(3.5), mm(190), mm(10), title, SECTION_SIZE, WHITE, bold=True)
    add_rect(doc, page, 0, SLIDE_H - mm(3), SLIDE_W, mm(3), ORANGE, radius=0)
    if tag:
        add_rect(doc, page, SLIDE_W - mm(57), mm(3.2), mm(46), mm(9), TEAL, radius=250)
        add_text(doc, page, SLIDE_W - mm(56), mm(4.2), mm(44), mm(6.5), tag, SMALL_SIZE, WHITE, bold=True)


def add_card(doc, page, x, y, w, h, title, body, fill, accent):
    add_rect(doc, page, x, y, w, h, fill, line=LINE, radius=260, line_width=20)
    add_rect(doc, page, x, y, mm(1.8), h, accent, radius=260)
    add_text(doc, page, x + mm(2.5), y + mm(1.5), w - mm(4), mm(8), title, MID_METRIC_SIZE, INK, bold=True)
    add_text(doc, page, x + mm(2.5), y + mm(9.5), w - mm(4), h - mm(11), body, BODY_SIZE, MUTED)


def build_title_slide(doc, page):
    add_rect(doc, page, 0, 0, SLIDE_W, SLIDE_H, BG, radius=0)
    add_rect(doc, page, mm(10), mm(18), mm(150), mm(78), NAVY, radius=350)
    add_rect(doc, page, mm(166), mm(18), mm(8), mm(78), ORANGE, radius=200)

    add_text(
        doc,
        page,
        mm(17),
        mm(28),
        mm(135),
        mm(26),
        "面向边缘计算的 4x4 脉动阵列阶段汇报",
        26,
        WHITE,
        bold=True,
    )
    add_text(
        doc,
        page,
        mm(17),
        mm(56),
        mm(130),
        mm(18),
        "WS / IS / OS 对比与改进型 DiP 进展",
        17,
        0xD9E4EE,
        bold=True,
    )
    add_text(
        doc,
        page,
        mm(17),
        mm(77),
        mm(130),
        mm(12),
        "统一口径：4x4 / 统一位宽 / 统一向量 / 统一脚本",
        SMALL_SIZE,
        0xD9E4EE,
    )

    chip_y = mm(26)
    for i, (name, color) in enumerate(
        [("WS", TEAL), ("IS", GREEN), ("OS", ORANGE), ("改进型 DiP", NAVY_2)]
    ):
        x = mm(182)
        width = mm(26) if i < 3 else mm(48)
        add_rect(doc, page, x, chip_y + i * mm(12.5), width, mm(8.5), color, radius=220)
        add_text(doc, page, x + mm(1), chip_y + i * mm(12.5) + mm(0.7), width - mm(2), mm(6.5), name, SMALL_SIZE, WHITE, bold=True)

    add_rect(doc, page, mm(182), mm(82), mm(76), mm(14), CARD_3, line=LINE, radius=220, line_width=20)
    add_text(doc, page, mm(184), mm(84), mm(72), mm(10), "本次汇报暂不展开功能覆盖率", SMALL_SIZE, INK, bold=True)

    add_text(doc, page, mm(10), SLIDE_H - mm(14), mm(120), mm(8), "组会汇报 | 2026-03-17", SMALL_SIZE, MUTED)
    add_text(doc, page, mm(150), SLIDE_H - mm(14), mm(110), mm(8), "主题：比较基线数据流，并以改进型 DiP 为中心", SMALL_SIZE, MUTED)


def build_scope_slide(doc, page):
    decorate_standard_slide(doc, page, "课题主线与当前实验口径", "组会摘要")

    add_rect(doc, page, mm(10), mm(25), mm(258), mm(24), CARD_3, line=LINE, radius=260, line_width=20)
    add_text(
        doc,
        page,
        mm(13),
        mm(29),
        mm(250),
        mm(16),
        "在统一 4x4 平台上比较 WS / IS / OS 三种传统数据流，并以改进型 DiP 为核心，"
        "围绕边缘计算关注的面积、功耗、时序与实现代价建立证据链。",
        BODY_SIZE,
        INK,
        bold=True,
    )

    add_card(doc, page, mm(10), mm(57), mm(62), mm(35), "WS", "权重尽量驻留在 PE\n输入流动，部分和传播\n作为传统基线 1", CARD, TEAL)
    add_card(doc, page, mm(76), mm(57), mm(62), mm(35), "IS", "输入尽量驻留在 PE\n权重流动，部分和传播\n作为传统基线 2", CARD_2, GREEN)
    add_card(doc, page, mm(142), mm(57), mm(62), mm(35), "OS", "输出/部分和驻留在 PE\n本地累加后统一读出\n作为传统基线 3", CARD_3, ORANGE)
    add_card(doc, page, mm(208), mm(57), mm(60), mm(35), "改进型 DiP", "对角输入传播\n配合旋转权重布局\n论文重点优化对象", CARD_4, NAVY_2)

    add_rect(doc, page, mm(10), mm(104), mm(258), mm(18), NAVY_2, radius=260)
    add_text(
        doc,
        page,
        mm(14),
        mm(108),
        mm(250),
        mm(10),
        "统一接口 / 统一 test vectors / 统一 Makefile / 统一 ASIC handoff 目录",
        BODY_SIZE,
        WHITE,
        bold=True,
    )


def build_progress_slide(doc, page):
    decorate_standard_slide(doc, page, "当前工程进展", "不含功能覆盖率")

    add_card(
        doc,
        page,
        mm(10),
        mm(26),
        mm(118),
        mm(26),
        "统一前端平台",
        "四套 4x4 标准 wrapper 已整理，\nREADME 与教学文档已连通。",
        CARD,
        TEAL,
    )
    add_card(
        doc,
        page,
        mm(10),
        mm(56),
        mm(118),
        mm(26),
        "统一回归与脚本",
        "公共 Makefile、txt 向量、\n批量回归与日志汇总已稳定可用。",
        CARD_2,
        GREEN,
    )
    add_card(
        doc,
        page,
        mm(10),
        mm(86),
        mm(118),
        mm(26),
        "中文材料与论文准备",
        "新手导读、数据流评审、教学图解、\n论文大纲已补齐。",
        CARD_3,
        ORANGE,
    )

    add_rect(doc, page, mm(138), mm(26), mm(130), mm(86), CARD_4, line=LINE, radius=260, line_width=20)
    add_text(doc, page, mm(143), mm(31), mm(120), mm(10), "阶段性状态", MID_METRIC_SIZE, INK, bold=True)
    add_text(
        doc,
        page,
        mm(143),
        mm(43),
        mm(120),
        mm(46),
        bullet_lines(
            [
                "make regress 已通过，四套数据流前端验证链路打通",
                "商业流程目录已统一为 VCS -> DC -> FM -> ICC2 -> Calibre",
                "后端实跑待另一台具备工艺库的服务器",
                "本次 PPT 有意不展开功能覆盖率部分",
            ]
        ),
        BODY_SIZE,
        INK,
    )

    add_rect(doc, page, mm(138), mm(92), mm(130), mm(20), NAVY_2, radius=240)
    add_text(doc, page, mm(143), mm(97), mm(122), mm(10), "现阶段已经具备：公平前端比较 + DiP 持续优化 + 后端承接脚本", SMALL_SIZE, WHITE, bold=True)


def build_dip_slide(doc, page):
    decorate_standard_slide(doc, page, "改进型 DiP 的 RTL 优化", "边缘导向")

    add_card(
        doc,
        page,
        mm(10),
        mm(27),
        mm(82),
        mm(58),
        "1. stage1_mac_en",
        "把“这一拍是否真的需要 MAC”\n前移到 stage1 并寄存，\n减少无效乘加路径翻转。",
        CARD,
        TEAL,
    )
    add_card(
        doc,
        page,
        mm(99),
        mm(27),
        mm(82),
        mm(58),
        "2. invalid 周期保持",
        "input_row_valid=0 时不再重写\nstream_input_row_data，\n隔离空拍总线切换。",
        CARD_2,
        GREEN,
    )
    add_card(
        doc,
        page,
        mm(188),
        mm(27),
        mm(80),
        mm(58),
        "3. 输出寄存稳定",
        "只有真正捕获到底部结果行时\n才更新 output_row_data_reg，\n避免输出总线空拍抖动。",
        CARD_3,
        ORANGE,
    )

    add_rect(doc, page, mm(10), mm(95), mm(258), mm(20), CARD_4, line=LINE, radius=240, line_width=20)
    add_text(
        doc,
        page,
        mm(14),
        mm(100),
        mm(250),
        mm(10),
        "优化目标：在不破坏 DiP 数据流语义的前提下，降低无效翻转、控制开销和输出抖动，更贴近边缘低功耗场景。",
        BODY_SIZE,
        INK,
        bold=True,
    )


def build_results_slide(doc, page):
    decorate_standard_slide(doc, page, "当前结果快照", "截至 2026-03-17")

    add_rect(doc, page, mm(10), mm(27), mm(92), mm(84), CARD, line=LINE, radius=260, line_width=20)
    add_text(doc, page, mm(15), mm(32), mm(84), mm(10), "功能正确性", MID_METRIC_SIZE, INK, bold=True)
    add_text(doc, page, mm(15), mm(46), mm(80), mm(16), "1072 / 1072 PASS", BIG_METRIC_SIZE, NAVY, bold=True)
    add_text(doc, page, mm(15), mm(63), mm(80), mm(8), "统一 regress 总通过", SMALL_SIZE, MUTED)
    add_text(doc, page, mm(15), mm(77), mm(80), mm(14), "268 / 268 PASS", BIG_METRIC_SIZE, TEAL, bold=True)
    add_text(doc, page, mm(15), mm(94), mm(80), mm(8), "DiP .txt 向量全通过", SMALL_SIZE, MUTED)

    grid_x = mm(112)
    grid_y = mm(27)
    cell_w = mm(74)
    cell_h = mm(26)
    gap_x = mm(6)
    gap_y = mm(6)
    metrics = [
        ("avg_skip_pct", "52.41%", CARD_2, GREEN),
        ("active MAC", "8162 / 17152", CARD_3, ORANGE),
        ("LUT / FF / DSP", "1286 / 1920 / 16", CARD, TEAL),
        ("Power", "0.100 W / 0.030 W", CARD_4, NAVY_2),
        ("Setup Slack", "+1.546 ns", CARD_2, GREEN),
        ("规模", "统一 4x4", CARD_3, ORANGE),
    ]
    for idx, (title, value, fill, accent) in enumerate(metrics):
        row = idx // 2
        col = idx % 2
        x = grid_x + col * (cell_w + gap_x)
        y = grid_y + row * (cell_h + gap_y)
        add_rect(doc, page, x, y, cell_w, cell_h, fill, line=LINE, radius=220, line_width=20)
        add_rect(doc, page, x, y, mm(1.6), cell_h, accent, radius=220)
        add_text(doc, page, x + mm(2.2), y + mm(2), cell_w - mm(4), mm(6), title, SMALL_SIZE, MUTED, bold=True)
        add_text(doc, page, x + mm(2.2), y + mm(9), cell_w - mm(4), mm(10), value, MID_METRIC_SIZE, INK, bold=True)

    add_rect(doc, page, mm(112), mm(117), mm(156), mm(10), NAVY_2, radius=200)
    add_text(doc, page, mm(116), mm(119), mm(148), mm(6), "注：当前时序为综合态结果；真正的 hold / post-route 结论留待下一阶段后端。", SMALL_SIZE, WHITE, bold=True)


def build_next_steps_slide(doc, page):
    decorate_standard_slide(doc, page, "下一步与组会讨论", "后端前夕")

    add_rect(doc, page, mm(10), mm(28), mm(124), mm(84), CARD_2, line=LINE, radius=260, line_width=20)
    add_text(doc, page, mm(15), mm(33), mm(116), mm(10), "下一步任务", MID_METRIC_SIZE, INK, bold=True)
    add_text(
        doc,
        page,
        mm(15),
        mm(46),
        mm(114),
        mm(54),
        bullet_lines(
            [
                "在目标服务器补齐工艺库路径与 libs.env",
                "依次跑 DC -> FM -> 后仿 -> ICC2 -> Calibre",
                "汇总 WS / IS / OS / 改进型 DiP 的面积、功耗、时序对比",
                "开始写论文第 4、5 章初稿",
            ]
        ),
        BODY_SIZE,
        INK,
    )

    add_rect(doc, page, mm(144), mm(28), mm(124), mm(84), CARD_3, line=LINE, radius=260, line_width=20)
    add_text(doc, page, mm(149), mm(33), mm(116), mm(10), "希望组会帮助确认", MID_METRIC_SIZE, INK, bold=True)
    add_text(
        doc,
        page,
        mm(149),
        mm(46),
        mm(114),
        mm(54),
        bullet_lines(
            [
                "第一轮后端优先使用哪套工艺库最稳妥",
                "后端对比优先强调面积 / 动态功耗 / WNS 的哪几项",
                "是否需要补 1 到 2 张更直观的对比图表用于论文",
                "组会后是否先集中把改进型 DiP 的证据链拉通",
            ]
        ),
        BODY_SIZE,
        INK,
    )

    add_rect(doc, page, mm(10), mm(120), mm(258), mm(8), ORANGE, radius=180)
    add_text(doc, page, mm(14), mm(121), mm(250), mm(6), "本周目标：先把改进型 DiP 的后端证据链拉通，再回到跨数据流公平比较。", SMALL_SIZE, WHITE, bold=True)


def connect_office(port: int):
    local_ctx = uno.getComponentContext()
    resolver = local_ctx.ServiceManager.createInstanceWithContext(
        "com.sun.star.bridge.UnoUrlResolver", local_ctx
    )
    for _ in range(60):
        try:
            return resolver.resolve(
                f"uno:socket,host=127.0.0.1,port={port};urp;StarOffice.ComponentContext"
            )
        except Exception:
            time.sleep(0.2)
    raise RuntimeError("Failed to connect to LibreOffice headless service.")


def build_deck(out_dir: Path, odp_name: str, pptx_name: str) -> tuple[Path, Path]:
    out_dir.mkdir(parents=True, exist_ok=True)
    profile = out_dir / ".lo_profile"
    port = 2107
    proc = subprocess.Popen(
        [
            "soffice",
            f"-env:UserInstallation=file://{profile}",
            "--headless",
            "--invisible",
            "--norestore",
            "--nodefault",
            "--nofirststartwizard",
            f"--accept=socket,host=127.0.0.1,port={port};urp;StarOffice.ComponentContext",
        ],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )

    try:
        ctx = connect_office(port)
        smgr = ctx.ServiceManager
        desktop = smgr.createInstanceWithContext("com.sun.star.frame.Desktop", ctx)
        doc = desktop.loadComponentFromURL("private:factory/simpress", "_blank", 0, ())

        build_title_slide(doc, get_slide(doc, 0))
        build_scope_slide(doc, get_slide(doc, 1))
        build_progress_slide(doc, get_slide(doc, 2))
        build_dip_slide(doc, get_slide(doc, 3))
        build_results_slide(doc, get_slide(doc, 4))
        build_next_steps_slide(doc, get_slide(doc, 5))

        odp_path = out_dir / odp_name
        pptx_path = out_dir / pptx_name
        doc.storeAsURL(file_url(odp_path), ())
        doc.storeAsURL(
            file_url(pptx_path),
            (make_prop("FilterName", "Impress MS PowerPoint 2007 XML"),),
        )
        doc.close(True)
        return odp_path, pptx_path
    finally:
        proc.terminate()
        try:
            proc.wait(timeout=5)
        except Exception:
            proc.kill()


def main() -> None:
    parser = argparse.ArgumentParser(description="Build the group meeting PPT.")
    parser.add_argument(
        "--out-dir",
        type=Path,
        default=Path(__file__).resolve().parent,
        help="Output directory for the deck files.",
    )
    parser.add_argument(
        "--odp-name",
        default="edge_systolic_group_meeting_20260317.odp",
        help="Intermediate ODP filename.",
    )
    parser.add_argument(
        "--pptx-name",
        default="edge_systolic_group_meeting_20260317.pptx",
        help="Final PPTX filename.",
    )
    args = parser.parse_args()

    odp_path, pptx_path = build_deck(args.out_dir, args.odp_name, args.pptx_name)
    print(f"Generated: {odp_path}")
    print(f"Generated: {pptx_path}")


if __name__ == "__main__":
    main()
